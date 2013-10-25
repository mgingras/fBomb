(function() {
  var bombs, createInfoWindow, lastOpenInfoWin, map, mapBomb, retreiveBombs;

  map = void 0;

  bombs = [];

  $(document).ready(function() {
    var mapOptions;
    mapOptions = void 0;
    mapOptions = void 0;
    mapOptions = {
      zoom: 2,
      center: new google.maps.LatLng(5, -30),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoomControl: true,
      disableDefaultUI: true
    };
    return map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  });

  $(function() {
    return setInterval(retreiveBombs, 1000);
  });

  retreiveBombs = function() {
    return $.get("data", function(tweets) {
      var i, numBombs, _results;
      numBombs = tweets.length;
      i = 0;
      _results = [];
      while (i < numBombs) {
        if ($.inArray(tweets[i].id, bombs) < 0) {
          mapBomb(tweets[i].text, tweets[i].coordinates);
          bombs.push(tweets[i].id);
        }
        _results.push(i++);
      }
      return _results;
    });
  };

  mapBomb = function(text, coords) {
    var bomb, bombGif, lat, lng, marker, random, signPost, zoom;
    lat = coords[0];
    lng = coords[1];
    zoom = map.getZoom();
    random = Math.random() * 100000;
    bombGif = "/img/fbomb.gif?";
    signPost = "/img/signPost.png";
    bomb = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      icon: bombGif + random,
      optimized: false,
      draggable: false,
      zIndex: 10,
      map: map
    });
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      title: text,
      icon: signPost,
      raiseOnDrag: false,
      draggable: false,
      animation: google.maps.Animation.DROP
    });
    createInfoWindow(marker, text);
    return setTimeout((function() {
      bomb.setMap(null);
      return marker.setMap(map);
    }), 2500);
  };

  lastOpenInfoWin = null;

  createInfoWindow = function(marker, text) {
    var infowindow;
    infowindow = new google.maps.InfoWindow({
      content: text,
      maxWidth: 150
    });
    return google.maps.event.addListener(marker, "click", function() {
      if (lastOpenInfoWin) {
        lastOpenInfoWin.close();
      }
      lastOpenInfoWin = infowindow;
      return infowindow.open(marker.get("map"), marker);
    });
  };

}).call(this);
