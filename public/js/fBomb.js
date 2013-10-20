var map;
var bombs = [];


$(document).ready(function() {
  var mapOptions;
  mapOptions = void 0;
  mapOptions = {
    zoom: 2,
    center: new google.maps.LatLng(5,-30),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDoubleClickZoom: true,
    scrollwheel: false,
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
      if(tweets[i].text == "" || tweets[i].text == null){
        console.log(tweets[i].text);
      }
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
    icon: '/img/fbomb.gif?'+ random,
    optimized: false,
    draggable:false,
    zIndex:10,
    map: map
  });
  bombs.push(bomb);
  var signPost = '/img/signPost.png?';
  var marker = new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng),
    title: text,
    icon: signPost + random,
    raiseOnDrag: false,
    draggable:false,
    zIndex: 9999,
    map: map
  });
  //create an options object
  var tooltipOptions={
    marker:marker,
    content:text,
    cssClass:'tooltip' // name of a css class to apply to tooltip
  };

// create the tooltip
createInfoWindow(marker, text);
createTooltip(marker,text);
setTimeout(function(){bomb.setMap(null)},4000);
// console.log($('img[src="'+marker.icon+'"]'));
// $('img[src="'+marker.icon+'"]').popover({pacement:'top', trigger: 'click', title:text});
// $('img[src="'+marker.icon+'"]').popover('show');

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
function createTooltip(marker, key) {
  //create a tooltip 
  var tooltipOptions={
    marker:marker,
    map:map,
    content:key,
    cssClass:'tooltip' // name of a css class to apply to tooltip
  };
  var tooltip = new Tooltip(tooltipOptions);
}



