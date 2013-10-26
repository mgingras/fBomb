(function() {
  var bombs, createInfoWindow, lastOpenInfoWin, map, mapBomb, retreiveBombs;

  map = void 0;

  bombs = [];

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

  $(function() {
    return setInterval(retreiveBombs, 1000);
  });

  retreiveBombs = function() {
    return $.get("data", function(tweets) {
      var tweet, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = tweets.length; _i < _len; _i++) {
        tweet = tweets[_i];
        if ($.inArray(tweet.id, bombs) < 0) {
          console.log(tweet);
          mapBomb(tweet.text, tweet.coordinates);
          _results.push(bombs.push(tweet.id));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  };

  mapBomb = function(text, coords) {
    var bomb, bombGif, lat, lng, marker, random, signPost;
    lat = coords[1];
    lng = coords[0];
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

  lastOpenInfoWin = null;

  createInfoWindow = function(marker, text) {
    var infoWindow;
    infoWindow = new google.maps.InfoWindow({
      content: text,
      maxWidth: 150
    });
    return google.maps.event.addListener(marker, "click", function() {
      if (lastOpenInfoWin) {
        lastOpenInfoWin.close();
      }
      lastOpenInfoWin = infoWindow;
      return infoWindow.open(marker.get("map"), marker);
    });
  };

}).call(this);
