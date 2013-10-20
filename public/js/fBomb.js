var map;
var bombs = [];


$(document).ready(function() {
  var mapOptions;
  mapOptions = void 0;
  mapOptions = {
    zoom: 2,
    center: new google.maps.LatLng(5,-30),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
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
  var random = Math.random() * 100000;
  var bomb = new google.maps.Marker({
    position: new google.maps.LatLng(lat - 10, lng + 1),
    title: text,
    icon: '/img/fbomb.gif?'+ random,
    optimized: false,
    draggable:true,
    map: map
  });
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    title: text,
    icon: '/img/signPost.png?'+ random,
    optimized: false,
    map: map
  }); 

}