var map;

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
  return setInterval(retreiveBombs, 1000);
});

var retreiveBombs = function() {
  $.get("data", function(data) {
    console.log(data);
    var latlng, marker, text;
    for (var i = 0; i < data.length; i++) {
      text = data[i].text;
      var random = Math.random() * 100000;
      bomb = new google.maps.Marker({
        position: new google.maps.LatLng(data[i].coordinates[0] - 10, data[i].coordinates[1] + 1),
        title: text,
        icon: '/img/fbomb.gif?'+ random,
        optimized: false,
        map: map
      });
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(data[i].coordinates[0], data[i].coordinates[1]),
        title: text,
        map: map
      }); 
    }
    });
};
