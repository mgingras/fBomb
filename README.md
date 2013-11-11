fBomb
=====

See where in the world the fBomb was dropped

Installation
-----

Fairly basic to set up your own instance of this application.

To set up your own version of this app, all you have to do is clone this repo and install the dependencies:

(debug step: comment out newrelic if you aren't going to be monitoring)

```shell
   $ git clone https://github.com/mgingras/fBomb.git
   $ npm install
```

I use foreman to populate the environment variables with the API keys, feel free to use whatever works for you to get them in your environemnt.

To do so, configure a ".env" file in the project's root directory with credentials from [https://dev.twitter.com](https://dev.twitter.com).

```env
consumer_key=[Consumer key]
consumer_secret=[Consumer Secret]
oauth_token=[Access token]
oauth_token_secret=[Access token secret]
gmaps=[Google Maps API key]
newrelic_key=[New Relic API Key]
app_name=[Application Name]
track=[Comma separated terms to track]
```


You can then run the app using the following:

``` $ foreman start ``` 

then just browse to localhost:5000 and you should see some fBombs!


(Alternatively you can hard code them in wherever they apply)

coffeeApp.coffee
 
```coffee
Twitter = new twit {
  consumer_key: [Consumer key]
  consumer_secret: [Consumer Secret]
  access_token: [Access token]
  access_token_secret: [Access token secret]
}
```
routes/index.js
```js
  res.render('index', { title: 'FBomb', api: process.env.gmaps });
````
newrelic.js
```js
  app_name : [process.env.app_name],
  //...
  license_key : process.env.newrelic_key,
````

then run the app using:

``` $ coffee coffeeApp.coffee```

and browse to localhost:3000

Configuration
----------

You can now configure what word to follow by modifying the .env file if you went that route or hard coding them into the following line in coffeeApp.coffee, so that 'track:process.env.track' is replaced by a comma separated string of whatever words you want to track.

```coffee
stream = Twitter.stream 'statuses/filter', {track:process.env.track}
```

Let me know if you have any questions!

<martin@mgingras.com>
