fBomb
=====

See where in the world the fBomb was dropped

###Installation
---

Fairly basic to set up your own instance of this application.

To set up your own version of this app, all you have to do is clone this repo and install the dependencies:

(debug step: comment out newrelic if you aren't going to be monitoring)

```shell
   $ git clone https://github.com/mgingras/fBomb.git
   $ npm install
```

###Configuration
---

For this applicaiton you need to get the API keys for Twitter [https://dev.twitter.com](https://dev.twitter.com) and Google Maps into your environment (or the code), and the App's name and words you want to track. Below are some methods of doing so:

####Export to Environment
You can set up your unix enivronment to have the necessary information by ```export``` (ing) them into your environment:

```bash
export consumer_key=[Consumer key] \
consumer_secret=[Consumer Secret] \
oauth_token=[Access token] \
oauth_token_secret=[Access token secret] \
gmaps=[Google Maps API key] \
app_name=[Application Name] \
track=[Comma separated terms to track]
```

You can then run the application with the following ```$ coffee coffeeApp.coffee``` (this requires coffeeScript installed)

Then just browse to localhost:3000 and you should see some fBombs drop!

####Heroku toolbelt - Foreman
To do so, using Foreman, from Heroku toolbelt, configure a ".env" file in the project's root directory.

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


####Hard code API keys
*You can hard code the values described in the above method wherever they apply (see below)*
In any of the below files, replace the entire "process.env.[key]" with the relevant data

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
```

then run the app using:

``` $ coffee coffeeApp.coffee```

and browse to localhost:3000

####Tracking
---

You can now configure what word to follow by modifying the .env file if you went that route or hard coding them into the following line in coffeeApp.coffee, so that 'track:process.env.track' is replaced by a comma separated string of whatever words you want to track.

```coffee
stream = Twitter.stream 'statuses/filter', {track:process.env.track}
```

Markers are customizable by replacing the fbomb.gif and signPost.png located in ./public/img/ . 


####Deployment
---
If you want to deploy this app, I suggest Heroku, they have lots of docs to help you out:
node.js: https://devcenter.heroku.com/articles/getting-started-with-nodejs
websockets: https://devcenter.heroku.com/articles/node-websockets


---

Let me know if you have any questions!

Martin   
<martin@mgingras.com>
