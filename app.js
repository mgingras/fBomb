
/**
 * Module dependencies.
 */

var express = require('express'),
routes = require('./routes'),
http = require('http'),
path = require('path'),
util = require('util'),
twitter = require('twitter');

var app = express();

// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

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
    stream.on('data', function(data) {
      if(data.geo){
        // data.geo.coordinates is an []
        // console.log(data.text + " : " + data.geo.coordinates);
        tweets.push({text: data.text, coordinates: data.geo.coordinates});
      }
    });
});

getData = function(callback){
  // console.log(tweets);
  callback(tweets);
  tweets = [];
}


app.get('/', routes.index);
app.get('/data', routes.data);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
