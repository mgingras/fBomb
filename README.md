fBomb
=====

See where in the world the fBomb was dropped

### Installation
---

Fairly basic to set up your own instance of this application.

To set up your own version of this app, all you have to do is clone this repo:

```bash

$ git clone https://github.com/mgingras/fBomb.git && cd fBomb && npm install

```

### Configuration
---

For this applicaiton you need to get the API keys for Twitter [https://dev.twitter.com](https://dev.twitter.com) and Google Maps. These are then inserted into config.json . You can also specify the name you want your applciation to have in this file.

Below is the current config.json file. replace the values surrounded by brackets ('[') with your API keys and configurations.

```json
{
  "consumer_key":"[CONSUMER_KEY]",
  "consumer_secret":"[CONSUMER_SECRET]",
  "oauth_token":"[OATH_TOKEN]",
  "oauth_token_secret":"[OAUTH_TOKEN_SECRET]",
  "gmaps":"[GMAPS_API_KEY]",
  "app_name":"[APP_NAME]",
  "track": "[WORDS_TO_TRACK]"
}
```

You can then run the application with the following:

```
$ coffee coffeeApp.coffee
```

If you have configured it correctly you should be able to browse to localhost:3000 and you see some bombs drop!

### Customization
---
#### Tracking
To change what is being tracked by the application, replace "[WORDS_TO_TRACK]" in config.json with a comma seperated list of words to track. (e.g. "fuck,fucks,fucking").   

#### Images
Markers are customizable by replacing 'fbomb.gif' and 'signPost.png' located in './public/img/'   

'fbomb.gif' is the initail indicator.   
'signpost.png' is the marker that drops after the gif animation and stays on the map.


### Deployment
---
If you want to deploy this app, I suggest Heroku, they have lots of docs to help you out:
node.js: https://devcenter.heroku.com/articles/getting-started-with-nodejs   
websockets: https://devcenter.heroku.com/articles/node-websockets

### Contact
---

Let me know if you have any questions!

Martin   
<martin@mgingras.com>
