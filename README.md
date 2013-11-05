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
```



You can then run the app using the following:

``` $ foreman start ``` 

then just browse to localhost:5000 and you should see some fBombs!


(Alternatively you can hard code them in coffeeApp.coffee)

```coffee
Twitter = new twit {
  consumer_key: [Consumer key]
  consumer_secret: [Consumer Secret]
  access_token: [Access token]
  access_token_secret: [Access token secret]
}
```

then run the app using:

``` $ coffee coffeeApp.coffee```

and browse to localhost:3000


#####*Also, please get your own Google Maps API key if you plan to use this extensively and replace line 33 of index.jade.*

Configuration
----------

You can now configure what word to follow by modifying one line in coffeeApp.coffee, so that 'fuck' is replaced by whatever you want to track.

```coffee
stream = Twitter.stream 'statuses/filter', {track:'fuck'}
```

Let me know if you have any questions!

<martin@mgingras.com>
