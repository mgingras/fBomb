/*
Constructor for the tooltip
@ param options an object containing: marker(required), content(required) and cssClass(a css class, optional)
@ see google.maps.OverlayView()
*/

function Tooltip(options) {

  // Now initialize all properties.
  this.marker_ = options.marker;
  this.content_ = options.content;
  this.map_ = options.marker.get('map');
  this.cssClass_ = options.cssClass || null;

  // We define a property to hold the content's
  // div. We'll actually create this div
  // upon receipt of the add() method so we'll
  // leave it null for now.
  this.div_ = null;

  //Explicitly call setMap on this overlay
  this.setMap(this.map_);
  var me = this;
  // Show tooltip on mouseover event.
  google.maps.event.addListener(me.marker_, 'mouseover', function() {
    me.show();
  });
  // Hide tooltip on mouseout event.
  google.maps.event.addListener(me.marker_, 'mouseout', function() {
    me.hide();
  });
}
// Now we extend google.maps.OverlayView()
Tooltip.prototype = new google.maps.OverlayView();

// onAdd is one of the functions that we must implement, 
// it will be called when the map is ready for the overlay to be attached.
Tooltip.prototype.onAdd = function() {

  // Create the DIV and set some basic attributes.
  var div = document.createElement('DIV');
  div.style.position = "absolute";
  // Hide tooltip
  div.style.visibility = "hidden";
  if(this.cssClass_)
  div.className += " "+this.cssClass_;

  //Attach content to the DIV.
  div.innerHTML = this.content_;

  // Set the overlay's div_ property to this DIV
  this.div_ = div;

  // We add an overlay to a map via one of the map's panes.
  // We'll add this overlay to the floatPane pane.
  var panes = this.getPanes();
  panes.floatPane.appendChild(this.div_);
	
}
// We here implement draw
Tooltip.prototype.draw = function() {

  // Position the overlay. We use the position of the marker
  // to peg it to the correct position, just northeast of the marker.
  // We need to retrieve the projection from this overlay to do this.
  var overlayProjection = this.getProjection();

  // Retrieve the coordinates of the marker
  // in latlngs and convert them to pixels coordinates.
  // We'll use these coordinates to place the DIV.
  var ne = overlayProjection.fromLatLngToDivPixel(this.marker_.getPosition());

  // Position the DIV.
  var div = this.div_;
  div.style.left = ne.x + 'px';
  div.style.top = ne.y + 'px';
    
}
// We here implement onRemove
Tooltip.prototype.onRemove = function() {
  this.div_.parentNode.removeChild(this.div_);
}

// Note that the visibility property must be a string enclosed in quotes
Tooltip.prototype.hide = function() {
  if (this.div_) {
    this.div_.style.visibility = "hidden";
  }
}

Tooltip.prototype.show = function() {
  if (this.div_) {
    this.div_.style.visibility = "visible";
  }
}