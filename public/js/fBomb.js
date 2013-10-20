var map;
var bombs = [];


$(document).ready(function() {
  var mapOptions;
  mapOptions = void 0;
  mapOptions = {
    zoom: 2,
    center: new google.maps.LatLng(5,-30),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    zoomControl: true,
    // disableDoubleClickZoom: true,
    // scrollwheel: false,
    disableDefaultUI: true
  };
  return map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
});

$(function() {
  return setInterval(retreiveBombs, 500); // Retreive more every 10 seconds
});

var retreiveBombs = function() {
  $.get("data", function(tweets) {
    var numBombs = tweets.length;
    for(var i = 0; i < numBombs; i++){
      if($.inArray(tweets[i].id, bombs) < 0){
        mapBomb(tweets[i].text, tweets[i].coordinates[0], tweets[i].coordinates[1]);
        bombs.push(tweets[i].id);
      }
      else{
      }
    }
    
  });
};
var mapBomb = function(text, lat, lng){
  // var latlng, marker, text, numBombs, rest;
  var zoom = map.getZoom();
  var random = Math.random() * 100000;
  var bombGif = '/img/fbomb.gif?';
  var signPost = '/img/signPost.png?';
  var bomb = new google.maps.Marker({
    // position: new google.maps.LatLng(lat - 10, lng + 1),
    position: new google.maps.LatLng(lat, lng),
    icon: bombGif + random,
    optimized: false,
    draggable:false,
    zIndex:10,
    map: map
  });
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    title: text,
    icon: signPost + random,
    raiseOnDrag: false,
    draggable:false,
    animation: google.maps.Animation.DROP
  });
  
    // create the tooltip
    createInfoWindow(marker, text);
    setTimeout(function(){
      bomb.setMap(null);
      marker.setMap(map);
    }, 2500);
}



  var lastOpenInfoWin = null;
  function createInfoWindow(marker, text) {
    //create an infowindow for this marker
    var infowindow = new google.maps.InfoWindow({
      content: text,
      maxWidth:150
    });
    //open infowindo on click event on marker.
    google.maps.event.addListener(marker, 'click', function() {
      if(lastOpenInfoWin) lastOpenInfoWin.close();
      lastOpenInfoWin = infowindow;
      infowindow.open(marker.get('map'), marker);
    });
  }
