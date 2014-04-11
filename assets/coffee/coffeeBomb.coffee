map = undefined
bombs = []

$(document).ready ->
  mapOptions =
    zoom: 2
    center: new google.maps.LatLng(5,-58)
    zoomControl: true
    disableDefaultUI: true

  map = new google.maps.Map document.getElementById("map-canvas"), mapOptions

  #Hackey workaround for IE
  window.location.origin = window.location.protocol + "//" + window.location.hostname + ((if window.location.port then ":" + window.location.port else ""))  unless window.location.origin

  # Configure WebSockets
  host = location.origin.replace /^http/, 'ws'
  ws =  new WebSocket host
  ws.onmessage = (event) ->
    data = JSON.parse event.data
    feedTweet data
    mapBomb data


mapBomb = (tweet) ->
  lat = tweet.coordinates[1]
  lng = tweet.coordinates[0]
  random = Math.random() * 100000
  bombGif = '/img/fbomb.gif?'
  signPost = '/img/signPost.png'
  bomb = new google.maps.Marker (
    position: new google.maps.LatLng lat, lng
    icon: bombGif + random
    optimized: false
    raiseOnDrag: false
    draggable: false
    map: map
  )
  marker= new google.maps.Marker (
    position: new google.maps.LatLng lat, lng
    icon: signPost
    raiseOnDrag: false
    draggable: false
    animation: google.maps.Animation.DROP
  )

  createInfoWindow marker, tweet
  setTimeout( ->
    bomb.setMap(null)
    marker.setMap(map)
  , 2500)


feedTweet = (tweet) ->
  text = urlize tweet.text
  img = '<div class="row"><img style="padding:0px;" src="' + tweet.profile_img + '" class="col-xs-2 img-rounded profilePic"></img>'
  # Time shit
  time = (new Date() - new Date(tweet.date)) / 60000
  hour = Math.floor(time / 60)
  minutes = Math.ceil(time % 60)
  time = if hour > 0 then hour + 'h' + minutes + 'm' else minutes + 'm'
  time = '<span class="col-xs-1 col-xs-offset-2 tweetTime">' + time + '</span>'
  username = '<p><strong class="col-xs-4" style="padding-left:5px;padding-right:3px;color:white;">' + tweet.name + '&nbsp;</strong><small class="col-xs-2" style="padding-left:5px;padding-right:0px"><a href="http://twitter.com/' + tweet.username + '">@' + tweet.username + '</a></small>' + time

  HTMLtext =  '<p class="col-xs-10 col-xs-offset-2 text">' + text + '</p>'
  content = '<div class="tweet">' + img + username + HTMLtext + '</div>'
  $(".tweetstream").prepend content

lastOpenInfoWin = null
createInfoWindow = (marker, tweet) ->
  # Time shit
  hour = tweet.date.match(/[0-9][0-9]:[0-9][0-9]/)[0]
  hour = parseInt(hour.match(/[0-9][0-9]/)[0]) - (new Date().getTimezoneOffset() / 60)
  hour += 24 if hour <= 0
  suffix = if hour > 12 then "pm" else "am"
  hour -= 12 if suffix is "pm"

  # URLize text
  text = urlize tweet.text, {target:'_blank'}

  content = '<img style="float:left;padding-right:2px;" align=left" src=' + tweet.profile_img + '><p><strong>' + tweet.name + '</strong><br><small><a href="http://twitter.com/' + tweet.username + '" target="_blank"">@' + tweet.username + '</a></small><br>' + hour.toString() + tweet.date.match(/:[0-9][0-9]/) + suffix +  ' - ' + tweet.date.match(/[0-9][0-9]/i)[0] + tweet.date.match(/\s[a-z][a-z][a-z]/i) + ' ' + (new Date().getFullYear()+'').slice(-2) + '<br>' + text

  if tweet.media_url
    infoWindow = new google.maps.InfoWindow (
      content: content + '<img border="0" style="width:100%;" align=left" src=' + tweet.media_url + '></p>'
      maxWidth: 175
    )
  else
    infoWindow = new google.maps.InfoWindow (
      content: content + '</p>'
      maxWidth: 225
    )
  google.maps.event.addListener marker, "click", ->
    lastOpenInfoWin.close() if lastOpenInfoWin
    lastOpenInfoWin = infoWindow
    infoWindow.open marker.get("map"), marker

