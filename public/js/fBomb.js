var map;

$(document).ready(function() {
  var mapOptions;
  mapOptions = void 0;
  mapOptions = {
    zoom: 3,
    center: new google.maps.LatLng(30.297018, 0.851440),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDefaultUI: true,
    disableDoubleClickZoom: true,
    zoomControl: true
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
      latlng = new google.maps.LatLng(data[i].coordinates[0], data[i].coordinates[1]);
      var random = Math.random() * 100000;
      marker = new google.maps.Marker({
        position: latlng,
        title: text,
        icon: '/img/fbomb.gif?'+ random,
        optimized: false
      });
      marker.setMap(map);
    }
    });
};
