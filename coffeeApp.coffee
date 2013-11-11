express = require 'express'
routes = require './routes'
newrelic = require 'newrelic'
http = require 'http'
path = require 'path'
util = require 'util'
compressor = require 'node-minify'
grunt = require 'grunt'
twit = require 'twit'

# Grunt task
grunt.loadNpmTasks 'grunt-contrib-coffee'
grunt.tasks [], {}, ->
  grunt.log.ok "Grunt: Done running tasks!"

# Expres
app = express()

# Configs
app.set 'port', process.env.PORT || 3000
app.set 'views', path.join __dirname, 'views'
app.set 'view engine', 'jade'
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# Minify
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
  app.use express.errorHandler {
    dumpExceptions: true,
    showStack: true
    }
  app.locals.pretty = true 
  
# Prod config
app.configure 'production', ->
  app.use express.errorHandler()

Twitter = new twit {
  consumer_key: process.env.consumer_key,
  consumer_secret: process.env.consumer_secret,
  access_token: process.env.oauth_token,
  access_token_secret: process.env.oauth_token_secret
}

# Temporary storage of tweets
tweets = []
retweets = []
# Array of re-tweeted screen_names to avoid spam
retweetedUsers= []

# Clears cache of tweets every 5 seconds
eraseTweets = -> tweets = []
setInterval eraseTweets, 5000

# Returns tweets to client
`getTweets = function() {return tweets;}`



stream = Twitter.stream 'statuses/filter', {track:process.env.track}

id = 0
# Logic to get tweets
stream.on 'tweet', (tweet) ->
  if tweet.coordinates
    tweets.push {text: "@" + tweet.user.screen_name + " : " + tweet.text, coordinates: tweet.coordinates.coordinates, id:id++}
    retweet tweet.user.screen_name, tweet.id_str, tweet.user.followers_count
  else if tweet.place
    if tweet.place.bounding_box
      if tweet.place.bounding_box.type is 'Polygon'
        centerPoint tweet.place.bounding_box.coordinates[0], (center) ->
          tweets.push {text: "@" + tweet.user.screen_name + " : " + tweet.text, coordinates: center, id:id++}
          retweet tweet.user.screen_name, tweet.id_str, tweet.user.followers_count
      else
        console.log 'WTF_Place: ' + util.inspect tweet.place
    else
      console.log 'placeWithNoBoundingBox' + util.inspect tweet.place

stream.on 'limit', (limitMessage) ->
  console.log "mgingras (limit): "
  console.log limitMessage
stream.on 'warning', (warning) ->
  console.log "mgingras (warning): "
  console.log warning
stream.on 'disconnect', (disconnectMessage) ->
  console.log "mgingras (disconnect): "
  console.log disconnectMessage
stream.on 'reconnect', (req, res, connectInterval) ->
  console.log "mgingras (reconnect): "
  console.log "Reqeuest: "
  console.log req
  console.log "Response: "
  console.log res
  console.log "Connection Interval: "
  console.log connectInterval
  
# Calculate the center of a bounding box for tweet
centerPoint = (coords, callback) ->
  centerPointX = 0
  centerPointY = 0
  for coord in coords
    centerPointX += coord[0]
    centerPointY += coord[1]
  callback [centerPointX / coords.length, centerPointY / coords.length]

limit = 1

# Reset the limit of retweets every 5 minutes
resetLimit = -> limit = 1
# setInterval resetLimit, 20000
setInterval resetLimit, 300000

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
        if err
          console.log "mgingras (Retweet Error): "
          console.log err
        else
          retweetedUsers.push(screen_name)
          retweets = []
  else
    if retweetedUsers.indexOf screen_name < 0
      retweets.push {screen_name: screen_name, tweetID: tweetID, followers: followers}


# Routes
app.get '/', routes.index
app.get '/data', routes.data

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'

process.on 'uncaughtException', (err) ->
    console.log 'Uncaught Error!!! : ' + err
