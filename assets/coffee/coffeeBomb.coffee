map = null
bombs = []

$(document).ready ->
  alert "Ready"
$(document).ready ->
  mapOptions = {
  zoom: 2,
  center: new google.maps.LatLng(5, -30),
  zoomControl: true,
  disableDefaultUI: true
  };
  map = new google.maps.Map document.getElementById("map-canvas"), mapOptions

retreiveBombs = -> 
  $.get "data", (tweets) ->
    for tweet in tweets
      if $.inArray(tweet.id, bombs) < 0
        mapBomb tweet.text, tweet.coordinates
        bombs.push tweet.id
        
$ -> setInterval(retreiveBombs, 1000)

mapBomb = (text, coords) ->
  lat = coords[0]
  lng = coords[1]
  random = Math.random() * 100000
  bombGif = '/img/fbomb.gif?'
  signPost = '/img/signPost.png'
  bomb = new google.maps.Marker {
      position: new google.maps.LatLng lat, lng
      icon: bombGif + random
      optimized: false
      raiseOnDrag: false
      draggable: false
      map: map
  }
  marker= new google.maps.Marker {
      position: new google.maps.LatLng lat, lng
      icon: signPost
      raiseOnDrag: false
      draggable: false
      animation: google.maps.Animation.DROP
  }
    
  createInfoWindow marker, text
  
  setTimeout( -> 
     bomb.setMap(null)
     marker.setMap(map)
  , 2500)
    
createInfoWindow = (marker, text) ->
  infoWindow = new google.maps.InfoWindow {
    context: text,
    maxWidth: 150
  }
  
  google.maps.event.addListener marker, 'click', ->
    if lastOpenInfoWin
      lastOpenInfoWin.close()
    lastOpenInfoWin = infoWindow
    infoWindow.open(marker.get 'map', marker)  