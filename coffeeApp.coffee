express = require 'express'
routes = require './routes'
newrelic = require 'newrelic'
http = require 'http'
path = require 'path'
util = require 'util'
twitter = require 'twitter'
compressor = require 'node-minify'
grunt = require 'grunt'
# fs = require 'fs'

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

tweets = []

twit = new twitter {
  consumer_key: process.env.consumer_key,
  consumer_secret: process.env.consumer_secret,
  access_token_key: process.env.oauth_token,
  access_token_secret: process.env.oauth_token_secret
}

twit.stream 'statuses/filter', {track:'fuck'}, (stream) ->
  id = 0
  stream.on 'data', (data) ->
    # fs.writeFile 'data.log', util.inspect(data)
    if data.coordinates
      # fs.writeFile 'coordinates.log', util.inspect(data.coordinates)
      tweets.push {text: "@" + data.user.screen_name + " : " + data.text, coordinates: data.coordinates.coordinates, id:id++}
    else if data.place
      # fs.writeFile 'place.log', util.inspect(data.place)
      if data.place.bounding_box
        fs.writeFile 'boundingBox.log', util.inspect(data.place.bounding_box)
        if data.place.bounding_box.type is 'Polygon'
          console.log data.text + util.inspect data.place
          centerPoint data.place.bounding_box.coordinates[0], (center) ->
            tweets.push {text: "@" + data.user.screen_name + " : " + data.text, coordinates: center, id:id++}
        else
          console.log 'WTF_Place: ' + util.inspect(data.place)
          # fs.writeFile 'wtfPlace.log', util.inspect(data.place)

centerPoint = (coords, callback) ->
  centerPointX = 0
  centerPointY = 0
  for coord in coords
    centerPointX += coord[0]
    centerPointY += coord[1]
  callback [centerPointX / coords.length, centerPointY / coords.length]

`getTweets = function() {return tweets;}`

eraseTweets = ->
  console.log("Erasing Tweets")
  tweets = []

setInterval eraseTweets, 5000

# Routes
app.get '/', routes.index
app.get '/data', routes.data

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'

process.on 'uncaughtException', (err) ->
    console.log 'Uncaught Error!!! : ' + err

