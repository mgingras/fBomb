
/**
 * Module dependencies.
 */

var express = require('express')
, routes = require('./routes')
, newrelic = require('newrelic')
, http = require('http')
, path = require('path')
, util = require('util')
, twitter = require('twitter')
, compressor = require('node-minify')
, grunt = require('grunt');

// grunt.task.init = function() {};
grunt.loadNpmTasks('grunt-contrib-coffee');
grunt.tasks([],{}, function() {
  grunt.log.ok('Grunt: Done running tasks!');
});


var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// Mini-me
new compressor.minify({
  type: 'uglifyjs',
  fileIn: 'assets/js/fBomb.js',
  fileOut: 'public/js/fBomb.min.js',
  callback: function(err){
    if(err) console.log("minify: " + err);
  }
});
new compressor.minify({
  type: 'uglifyjs',
  fileIn: 'assets/js/add2home.js',
  fileOut: 'public/js/add2home.min.js',
  callback: function(err){
    if(err) console.log("minify: " + err);
  }
});

// development only configuration
app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
  app.locals.pretty = true;
});

// production configuration
app.configure('production', function(){
  app.use(express.errorHandler());
});

var tweets = [];
var twit = new twitter({
    consumer_key: process.env.consumer_key,
    consumer_secret: process.env.consumer_secret,
    access_token_key: process.env.oauth_token,
    access_token_secret: process.env.oauth_token_secret
});
twit.stream('statuses/filter', {track:'fuck'}, function(stream) {
  var id = 0;
    stream.on('data', function(data) {
      if(data.geo){
        // data.geo.coordinates is an []
        // console.log(data.text + " : " + data.geo.coordinates);
        tweets.push({text: data.text, coordinates: data.geo.coordinates, id:id++});
      }
    });
});

getTweets = function(callback){
  // console.log(tweets);
  callback(tweets);
}

var eraseTweets = function(){
  console.log("Erasing tweets");
  tweets = [];
}

setInterval(eraseTweets, 10000);


app.get('/', routes.index);
app.get('/data', routes.data);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
