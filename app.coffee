express = require 'express'
routes = require './routes'
http = require 'http'
path = require 'path'
util = require 'util'
compressor = require 'node-minify'
grunt = require 'grunt'
twit = require 'twit'
WebSocketServer = require('ws').Server
config = require './config.json'

# Grunt tasks
grunt.loadNpmTasks 'grunt-contrib-coffee'
grunt.tasks [], {}, ->
  grunt.log.ok 'Grunt: Done running tasks!'

# Express
app = express()

# App Config stuff...
app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', path.join __dirname, 'views'
  app.set 'view engine', 'jade'
  app.use express.json()
  app.use express.urlencoded()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

# Minify JS and CSS
new compressor.minify {
  type: 'uglifyjs',
  fileIn: 'assets/js/fBomb.js',
  fileOut: 'public/js/fBomb.min.js',
  callback: (err) ->  if err
    console.log 'minify: ' + err
  }
new compressor.minify {
  type: 'yui-css',
  fileIn: 'public/css/add2home.css',
  fileOut: 'public/css/add2home.min.css',
  callback: (err) ->  if err
    console.log 'minify: ' + err
  }

# Dev config
app.configure 'development', ->
  app.use express.logger 'dev'
  app.use express.errorHandler {
    dumpExceptions: true,
    showStack: true
    }
  app.locals.pretty = true

# Prod config
app.configure 'production', ->
  app.use express.logger()
  app.use express.errorHandler()


# Create the http server...
server = http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'

# Configure WebServer for WebSockets, attach it to the server
wss = new WebSocketServer {server:server}

wss.on 'connection', (ws) ->
  console.log 'WebSocket Connection!'

# Configure Twitter API connection using API keys from environment
Twitter = new twit (
  consumer_key: config.consumer_key,
  consumer_secret: config.consumer_secret,
  access_token: config.oauth_token,
  access_token_secret: config.oauth_token_secret
)

# Temporary storage of tweets
retweets = []
# Array of re-tweeted screen_names to avoid spam
retweetedUsers= []


wss.broadcast = (data) ->
  for i of @clients
    @clients[i].send data

startStream = ->
  stream = Twitter.stream 'statuses/filter', {track: config.track}

  # Logic to handle tweets
  stream.on 'tweet', (tweet) ->
    retweet tweet.user.screen_name, tweet.id_str, tweet.user.followers_count
    tweetData = undefined
    if tweet.coordinates
      tweetData =
        username: tweet.user.screen_name
        name: tweet.user.name
        date: tweet.created_at
        text: tweet.text
        coordinates: tweet.coordinates.coordinates
        profile_img: tweet.user.profile_image_url
      tweetData['media_url'] = tweet.entities.media[0].media_url if tweet.entities.media
      wss.broadcast JSON.stringify tweetData
    else if tweet.place
      if tweet.place.bounding_box
        if tweet.place.bounding_box.type is 'Polygon'
          centerPoint tweet.place.bounding_box.coordinates[0], (center) ->
            tweetData =
                username: tweet.user.screen_name
                name: tweet.user.name
                date: tweet.created_at
                text: tweet.text
                coordinates: center
                profile_img: tweet.user.profile_image_url
            tweetData['media_url'] = tweet.entities.media[0].media_url if tweet.entities.media
            wss.broadcast JSON.stringify tweetData
        else
          console.log 'WTF Place: ' + util.inspect tweet.place
      else
        console.log 'Place without bounding_box: ' + util.inspect tweet.place

  # Twitter Error handling
  stream.on 'limit', (limitMessage) ->
    console.log 'mgingras (limit): ' + limitMessage.limit.track
  stream.on 'warning', (warning) ->
    console.log 'mgingras (warning): ' + warning.warning.code + ' : ' + warning.warning.message
  stream.on 'disconnect', (disconnectMessage) ->
    console.log 'mgingras (disconnect): ' + disconnectMessage.disconnect.reason
    setTimeout startStream, 5000 # In case of disconnect, wait 5 secs, try to connect again
  stream.on 'reconnect', (req, res, connectInterval) ->
    console.log 'mgingras (reconnect): '
    console.log 'Reqeuest: ' + req
    console.log 'Response: ' + res
    console.log 'Connection Interval: ' + connectInterval
  return
startStream()

# Calculate the center of a bounding box for tweet
centerPoint = (coords, callback) ->
  centerPointX = centerPointY = 0
  for coord in coords
    centerPointX += coord[0]
    centerPointY += coord[1]
  callback [centerPointX / coords.length, centerPointY / coords.length]


########### Retweet Stuff ###########
limit = 0

# Reset the limit of retweets every 10 minutes
setInterval ->
    limit=1
  , 600000


# Retweet logic
retweet = (screen_name, tweetID, followers) ->
  if limit isnt 0 && retweets.length > 0
    limit--
    mostPopular = 0
    index = 0
    for tweet in retweets
      if tweet.followers >= mostPopular
        mostPopular = tweet.followers
        index = _i
    Twitter.post 'statuses/retweet/:id', { id: retweets[index].tweetID }, (err) ->
      console.log 'mgingras (Retweet Error): ' + util.inspect err if err
      retweetedUsers.push screen_name
      retweets = []
  else
    if retweetedUsers.indexOf(screen_name) < 0
      tweetData =
        screen_name: screen_name
        tweetID: tweetID
        followers: followers
      retweets.push tweetData

# Routes
app.get '/', routes.index

# Error handling
process.on 'uncaughtException', (err) ->
  console.log 'Uncaught Error!!! : ' + err
