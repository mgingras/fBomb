map = undefined
bombs = []

$(document).ready ->
  mapOptions =
    zoom: 3
    center: new google.maps.LatLng(40, -1)
    zoomControl: true
    disableDefaultUI: true
    
  map = new google.maps.Map document.getElementById("map-canvas"), mapOptions

$ -> setInterval retreiveBombs, 1000
eraseBombs = -> bombs= []
$ -> setInterval eraseBombs, 10000

retreiveBombs = -> 
  $.get "data", (tweets) ->
    for tweet in tweets
      if $.inArray(tweet.id, bombs) < 0
        mapBomb tweet.text, tweet.coordinates
        bombs.push tweet.id

mapBomb = (text, coords) ->
  lat = coords[1]
  lng = coords[0]
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
  
  createInfoWindow marker, text
  setTimeout( -> 
     bomb.setMap(null)
     marker.setMap(map)
  , 2500)
  
lastOpenInfoWin = null
createInfoWindow = (marker, text) ->
  infoWindow = new google.maps.InfoWindow (
    content: text
    maxWidth: 150
  )
  google.maps.event.addListener marker, "click", ->
    lastOpenInfoWin.close() if lastOpenInfoWin
    lastOpenInfoWin = infoWindow
    infoWindow.open marker.get("map"), marker
