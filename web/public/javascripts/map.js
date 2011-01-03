var map;
var markers;
var popup;
var epsg4326 = new OpenLayers.Projection("EPSG:4326");

function createMap(divName, centre, zoom) {
   OpenLayers.Util.onImageLoadError = function() {
      this.src = "/openlayers/img/blank.gif";
   }

   map = new OpenLayers.Map(divName,
                            { maxExtent: new OpenLayers.Bounds(-20037508,-20037508,20037508,20037508),
                              numZoomLevels: 19,
                              maxResolution: 156543,
                              units: 'm',
                              projection: "EPSG:900913",
                              controls: [
                              new OpenLayers.Control.LayerSwitcher(),
                              new OpenLayers.Control.PanZoomBar(),
                              new OpenLayers.Control.MouseDefaults(),
                              new OpenLayers.Control.Permalink()
                              ],
                              displayProjection:  new OpenLayers.Projection("EPSG:4326") });

   var mapnik = new OpenLayers.Layer.OSM("OpenStreetMap",
                                         ["http://a.tile.openstreetmap.org/${z}/${x}/${y}.png",
                                          "http://b.tile.openstreetmap.org/${z}/${x}/${y}.png",
                                          "http://c.tile.openstreetmap.org/${z}/${x}/${y}.png"],
                                         { displayOutsideMaxExtent: true,
                                          transitionEffect: 'resize'});
   map.addLayer(mapnik);

   var cycle = new OpenLayers.Layer.OSM("OpenCycleMap",
                                        ["http://a.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
                                         "http://b.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png",
                                         "http://c.tile.opencyclemap.org/cycle/${z}/${x}/${y}.png"],
                                        { displayOutsideMaxExtent: true,
                                          transitionEffect: 'resize'});
   map.addLayer(cycle);
   
   var blank = new OpenLayers.Layer.TMS("No Map", 
                                         '',
                                        { type: 'png', getURL: getBlankURL, displayOutsideMaxExtent: true,
                                          transitionEffect: 'resize'});
                                         
   map.addLayer(blank);

   if (!map.getCenter()) map.setCenter(centre, zoom);
   map.events.register("moveend", map, updateLocation);
   map.events.register("changelayer", map, updateLocation);
   return map;
}

function getBlankURL(bounds) {
  return 'images/white.png';
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

    document.cookie = "_osm_location=" + lonlat.lon + "|" + lonlat.lat + "|" + zoom + "|" + layers + "; path=/";
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

function setMapLayers(layerConfig) {
  var l = 0;
  
  for (var layers = map.getLayersBy("isBaseLayer", true), i = 0; i < layers.length; i++) {
    var c = layerConfig.charAt(l++);
    
    if (c == "B") {
      map.setBaseLayer(layers[i]);
    }
  }
  
  while (layerConfig.charAt(l) == "B" || layerConfig.charAt(l) == "0") {
    l++;
  }
  
  for (var layers = map.getLayersBy("isBaseLayer", false), i = 0; i < layers.length; i++) {
    var c = layerConfig.charAt(l++);
    
    if (c == "T") {
      layers[i].setVisibility(true);
    } else if(c == "F") {
      layers[i].setVisibility(false);
    }
  }
}
