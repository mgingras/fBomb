(function() {
  var bombs, createInfoWindow, map, mapBomb, retreiveBombs;

  map = null;

  bombs = [];

  $(document).ready(function() {
    return alert("Ready");
  });

  $(document).ready(function() {
    var mapOptions;
    mapOptions = {
      zoom: 2,
      center: new google.maps.LatLng(5, -30),
      zoomControl: true,
      disableDefaultUI: true
    };
    return map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  });

  retreiveBombs = function() {
    return $.get("data", function(tweets) {
      var tweet, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = tweets.length; _i < _len; _i++) {
        tweet = tweets[_i];
        if ($.inArray(tweet.id, bombs) < 0) {
          mapBomb(tweet.text, tweet.coordinates);
          _results.push(bombs.push(tweet.id));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  };

  $(function() {
    return setInterval(retreiveBombs, 1000);
  });

  mapBomb = function(text, coords) {
    var bomb, bombGif, lat, lng, marker, random, signPost;
    lat = coords[0];
    lng = coords[1];
    random = Math.random() * 100000;
    bombGif = '/img/fbomb.gif?';
    signPost = '/img/signPost.png';
    bomb = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      icon: bombGif + random,
      optimized: false,
      raiseOnDrag: false,
      draggable: false,
      map: map
    });
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(lat, lng),
      icon: signPost,
      raiseOnDrag: false,
      draggable: false,
      animation: google.maps.Animation.DROP
    });
    createInfoWindow(marker, text);
    return setTimeout(function() {
      bomb.setMap(null);
      return marker.setMap(map);
    }, 2500);
  };

  createInfoWindow = function(marker, text) {
    var infoWindow;
    infoWindow = new google.maps.InfoWindow({
      context: text,
      maxWidth: 150
    });
    return google.maps.event.addListener(marker, 'click', function() {
      var lastOpenInfoWin;
      if (lastOpenInfoWin) {
        lastOpenInfoWin.close();
      }
      lastOpenInfoWin = infoWindow;
      return infoWindow.open(marker.get('map', marker));
    });
  };

}).call(this);
