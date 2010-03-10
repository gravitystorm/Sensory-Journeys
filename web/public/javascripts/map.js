var map;
var markers;
var popup;
var epsg4326 = new OpenLayers.Projection("EPSG:4326");

function createMap(divName, centre, zoom) {
   OpenLayers.Util.onImageLoadError = function() {
      this.src = "/images/osm_logo.png";
   }

   map = new OpenLayers.Map(divName,
                            { maxExtent: new OpenLayers.Bounds(-20037508,-20037508,20037508,20037508),
                              numZoomLevels: 19,
                              maxResolution: 156543,
                              units: 'm',
                              projection: "EPSG:900913",
                              controls: [
				new OpenLayers.Control.LayerSwitcher(),
				new OpenLayers.Control.Permalink('permalink'),
				//new OpenLayers.Control.Permalink('editlink', 'http://www.openstreetmap.org/edit.html'),
				new OpenLayers.Control.Attribution(),
				new OpenLayers.Control.PanZoomBar(),
				new OpenLayers.Control.MouseDefaults()
                              ],
                              displayProjection:  new OpenLayers.Projection("EPSG:4326") });

   var cycleattrib = '<b>OpenCycleMap.org - the <a href="http://www.openstreetmap.org">OpenStreetMap</a> Cycle Map</b><br />'
                   + '<a href="http://www.gravitystorm.co.uk/shine/cycle-info/">Key and More Info</a> | <a href="http://www.gravitystorm.co.uk/shine/cycle-map-help">Help</a> | <a href="http://www.gravitystorm.co.uk/shine/gps-recommendations">GPS</a><br />'
                   + 'Created by <a href="http://www.gravitystorm.co.uk">Andy Allan</a> and Dave Stubbs<br />'
                   + 'Sponsored by <a href="http://www.cloudmade.com">CloudMade</a> <br />'
                   ;
   var cmattrib = 'Map images copyright <a href="http://www.cloudmade.com">CloudMade</a><br />';
   var cmstandardattrib = '<b>CloudMade standard style</b><br />' + cmattrib;
   var cmmobileattrib = '<b>CloudMade mobile style</b><br />' + cmattrib;
   var cmnonamesattrib = '<b>CloudMade nonames style</b><br />A debug layer for OSM contributors<br />' + cmattrib;

   var cycle = new OpenLayers.Layer.TMS("OSM Cycle Map", 
                                        ["http://a.andy.sandbox.cloudmade.com/tiles/cycle/",
                                         "http://b.andy.sandbox.cloudmade.com/tiles/cycle/",
                                         "http://c.andy.sandbox.cloudmade.com/tiles/cycle/"],
                                        { type: 'png', getURL: getTileURL, displayOutsideMaxExtent: true,
                                          attribution: cycleattrib, transitionEffect: 'resize'});
   map.addLayer(cycle);

   var mapnik = new OpenLayers.Layer.TMS("CloudMade Fresh",
                                         ["http://a.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/997/256/",
                                          "http://b.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/997/256/",
					  "http://c.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/997/256/"],
                                         { type: 'png', getURL: getTileURL, displayOutsideMaxExtent: true,
					   attribution: cmstandardattrib, transitionEffect: 'resize'});
   map.addLayer(mapnik);

   var mobile = new OpenLayers.Layer.TMS("Fine Line",
                                            ["http://a.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/2/256/",
                                             "http://b.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/2/256/",
                                             "http://c.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/2/256/"],
                                             { type: 'png', getURL: getTileURL, displayOutsideMaxExtent: true,
					       attribution: cmmobileattrib, transitionEffect: 'resize'});
   map.addLayer(mobile);

   var nonames = new OpenLayers.Layer.TMS("NoNames style",
                                            ["http://a.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/3/256/",
                                             "http://b.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/3/256/",
                                             "http://c.tile.cloudmade.com/8bafab36916b5ce6b4395ede3cb9ddea/3/256/"],
                                             { type: 'png', getURL: getTileURL, displayOutsideMaxExtent: true,
                                               attribution: cmnonamesattrib, transitionEffect: 'resize'});
   map.addLayer(nonames);

   if (!map.getCenter()) map.setCenter(centre, zoom);
   map.events.register("moveend", map, updateLocation);
   map.events.register("changelayer", map, updateLocation);
   return map;
}

function getTileURL(bounds) {
   var res = this.map.getResolution();
   var x = Math.round((bounds.left - this.maxExtent.left) / (res * this.tileSize.w));
   var y = Math.round((this.maxExtent.top - bounds.top) / (res * this.tileSize.h));
   var z = this.map.getZoom();
   var limit = Math.pow(2, z);

   if (y < 0 || y >= limit)
   {
     return null;
   }
   else
   {
     x = ((x % limit) + limit) % limit;

     var url = this.url;
     var path = z + "/" + x + "/" + y + ".png";

     if (url instanceof Array) {
         url = this.selectUrl(path, url);
     }
     return url + path;

   }
}

function mercatorToLonLat(merc) {
   var lon = (merc.lon / 20037508.34) * 180;
   var lat = (merc.lat / 20037508.34) * 180;

   lat = 180/Math.PI * (2 * Math.atan(Math.exp(lat * Math.PI / 180)) - Math.PI / 2);

   return new OpenLayers.LonLat(lon, lat);
}

function lonLatToMercator(ll) {
   var lon = ll.lon * 20037508.34 / 180;
   var lat = Math.log(Math.tan((90 + ll.lat) * Math.PI / 360)) / (Math.PI / 180);

   lat = lat * 20037508.34 / 180;

   return new OpenLayers.LonLat(lon, lat);
}

function scaleToZoom(scale) {
   return Math.log(360.0/(scale * 512.0)) / Math.log(2.0);
}

function updateLocation() {
    var lonlat = map.getCenter().clone().transform(map.getProjectionObject(), epsg4326);
    var zoom = map.getZoom();
    var layers = getMapLayers();
    var extents = map.getExtent().clone().transform(map.getProjectionObject(), epsg4326);
    var expiry = new Date();

    expiry.setYear(expiry.getFullYear() + 10); 
    document.cookie = "_osm_location=" + lonlat.lon + "|" + lonlat.lat + "|" + zoom + "|" + layers + "; expires=" + expiry.toGMTString();
  }

function getMapLayers() {
   var layerConfig = "";

   for (var layers = map.getLayersBy("isBaseLayer", true), i = 0; i < layers.length; i++) {
      layerConfig += layers[i] == map.baseLayer ? "B" : "0";
   }

   for (var layers = map.getLayersBy("isBaseLayer", false), i = 0; i < layers.length; i++) {
      layerConfig += layers[i].getVisibility() ? "T" : "F";
   }

   return layerConfig;
}

function setMapExtent(extent) {
   map.zoomToExtent(extent.clone().transform(epsg4326, map.getProjectionObject()));
}