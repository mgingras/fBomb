map = undefined
bombs = []
$(document).ready ->
  mapOptions = undefined
  mapOptions = undefined
  mapOptions =
    zoom: 2
    center: new google.maps.LatLng(5, -30)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    zoomControl: true
    
    # disableDoubleClickZoom: true,
    # scrollwheel: false,
    disableDefaultUI: true

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

$ ->
  setInterval retreiveBombs, 1000 # Retreive more every second

retreiveBombs = ->
  $.get "data", (tweets) ->
    numBombs = tweets.length
    i = 0

    while i < numBombs
      if $.inArray(tweets[i].id, bombs) < 0
        mapBomb tweets[i].text, tweets[i].coordinates
        bombs.push tweets[i].id
      i++
      
mapBomb = (text, coords) ->
  lat = coords[0]
  lng = coords[1]
  
  # var latlng, marker, text, numBombs, rest;
  zoom = map.getZoom()
  random = Math.random() * 100000
  bombGif = "/img/fbomb.gif?"
  signPost = "/img/signPost.png"
  bomb = new google.maps.Marker(
    
    # position: new google.maps.LatLng(lat - 10, lng + 1),
    position: new google.maps.LatLng(lat, lng)
    icon: bombGif + random
    optimized: false
    draggable: false
    zIndex: 10
    map: map
  )
  marker = new google.maps.Marker(
    position: new google.maps.LatLng(lat, lng)
    title: text
    icon: signPost
    raiseOnDrag: false
    draggable: false
    animation: google.maps.Animation.DROP
  )
  
  # create the tooltip
  createInfoWindow marker, text
  setTimeout (->
    bomb.setMap null
    marker.setMap map
  ), 2500

lastOpenInfoWin = null 
createInfoWindow = (marker, text) ->
  
  #create an infowindow for this marker
  infowindow = new google.maps.InfoWindow(
    content: text
    maxWidth: 150
  )
  
  #open infowindo on click event on marker.
  google.maps.event.addListener marker, "click", ->
    lastOpenInfoWin.close()  if lastOpenInfoWin
    lastOpenInfoWin = infowindow
    infowindow.open marker.get("map"), marker
