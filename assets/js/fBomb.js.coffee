# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = undefined

$(document).ready ->
  mapOptions = undefined
  mapOptions =
    zoom: 3
    center: new google.maps.LatLng(30.297018, 0.851440)
    mapTypeId: google.maps.MapTypeId.ROADMAP
    disableDefaultUI: true
    disableDoubleClickZoom: true
    zoomControl: true

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)


# $ ->
#   setInterval retreiveBombs, 1000


# retreiveBombs = ->
#   $.getJSON "/data/data.json", (data) -> 
#     $.each data, (key, val) ->
#       lat = val[0].coordinates[0]
#       lng = val[0].coordinates[1]
#       text = val[0].text
#       latlng = new google.maps.LatLng(lat,lng)
#       marker = new google.maps.Marker({
#         position: latlng ,
#         title: text
#       })
#       marker.setMap(map)
