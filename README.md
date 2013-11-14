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

I use foreman to populate the environment variables with the API keys, feel free to use whatever works for you to get them in your environment.

To do so, using foreman configure the ".env" file in the project's root directory with credentials from [https://dev.twitter.com](https://dev.twitter.com) and Google's API.

```env
consumer_key=[Consumer key]
consumer_secret=[Consumer Secret]
oauth_token=[Access token]
oauth_token_secret=[Access token secret]
gmaps=[Google Maps API key]
app_name=[Application Name]
track=[Comma separated terms to track]
```


You can then run the app using the following:

``` $ foreman start ``` 

Then just browse to localhost:5000 and you should see some fBombs drop!


(Alternatively you can hard code them in wherever they apply)

coffeeApp.coffee
 
```coffee
Twitter = new twit {
  consumer_key: [Consumer key]
  consumer_secret: [Consumer Secret]
  access_token: [Access token]
  access_token_secret: [Access token secret]
}

...

stream = Twitter.stream 'statuses/filter', {track:process.env.track}

```
routes/index.js
```js
  res.render('index', { title: 'FBomb', api: process.env.gmaps });
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

Markers are customizable by replacing the fbomb.gif and signPost.png located in ./public/img/ . 

Let me know if you have any questions!

<martin@mgingras.com>
