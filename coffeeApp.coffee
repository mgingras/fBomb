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
# Clears cache of tweets
setInterval eraseTweets, 5000
eraseTweets = -> tweets = []
# Returns tweets to client
`getTweets = function() {return tweets;}`

stream = Twitter.stream 'statuses/filter', {track:'fuck'}

id = 0
stream.on 'tweet', (tweet) ->
  if tweet.coordinates
    tweets.push {text: "@" + tweet.user.screen_name + " : " + tweet.text, coordinates: tweet.coordinates.coordinates, id:id++}
    retweet tweet.user.screen_name, tweet.id_str
  else if tweet.place
    if tweet.place.bounding_box
      if tweet.place.bounding_box.type is 'Polygon'
        centerPoint tweet.place.bounding_box.coordinates[0], (center) ->
          tweets.push {text: "@" + tweet.user.screen_name + " : " + tweet.text, coordinates: center, id:id++}
          retweet tweet.user.screen_name, tweet.id_str
      else
        console.log 'WTF_Place: ' + util.inspect tweet.place
    else
      console.log 'placeWithNoBoundingBox' + util.inspect tweet.place

centerPoint = (coords, callback) ->
  centerPointX = 0
  centerPointY = 0
  for coord in coords
    centerPointX += coord[0]
    centerPointY += coord[1]
  callback [centerPointX / coords.length, centerPointY / coords.length]



# Array of re-tweeted screen_names
twitterUsernameArray = []
# 350 per hour, 50 per min, we'll do 45 so we avoid hitting the limit
limit = 0
setInterval resetLimit, 60000
resetLimit = -> limit = 0



retweet = (screen_name, tweetID) ->
  if limit is 0
    return
  else limit--
  if twitterUsernameArray[screen_name]
    console.log screen_name + " found!"
  else #if screen_name is "martin_gingras"
    Twitter.post 'statuses/retweet/:id', { id: tweetID }, (err) ->
      if err
       console.log err
      else
        twitterUsernameArray[screen_name] = screen_name


# Routes
app.get '/', routes.index
app.get '/data', routes.data

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'

process.on 'uncaughtException', (err) ->
    console.log 'Uncaught Error!!! : ' + err

