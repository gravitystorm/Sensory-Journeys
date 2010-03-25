var emotionIcons = {
  "happy": {externalGraphic: "/openlayers/img/marker-green.png"},
  "neutral": {externalGraphic: "/openlayers/img/marker-gold.png"},
  "sad": {externalGraphic: "/openlayers/img/marker.png"}
};

var SHADOW_Z_INDEX = 9;
var MARKER_Z_INDEX = 10;

var markerStyle = new OpenLayers.StyleMap({
                    backgroundGraphic: "/images/marker_shadow.png",
                    
                    // Makes sure the background graphic is placed correctly relative
                    // to the external graphic.
                    backgroundXOffset: 0,
                    backgroundYOffset: -7,
                    
                    // Set the z-indexes of both graphics to make sure the background
                    // graphics stay in the background (shadows on top of markers looks
                    // odd; let's not do that).
                    graphicZIndex: MARKER_Z_INDEX,
                    backgroundGraphicZIndex: SHADOW_Z_INDEX,
                    
                    pointRadius: 10
                    });

markerStyle.addUniqueValueRules("default", "name", emotionIcons);

var markers = new OpenLayers.Layer.Vector("markers",
                { protocol: new OpenLayers.Protocol.HTTP({
                    url: '/marker/all.kml',
                    format: new OpenLayers.Format.KML({extractStyles: false, extractAttributes: true})
                  }),
                  strategies: [new OpenLayers.Strategy.Fixed()],
                  projection: new OpenLayers.Projection("EPSG:4326"),
                  styleMap: markerStyle
                });

var newmarkers = new OpenLayers.Layer.Vector("New Markers", 
                { styleMap: new OpenLayers.StyleMap({
                    // Set the external graphic and background graphic images.
                    externalGraphic: "/openlayers/img/marker-blue.png",
                    backgroundGraphic: "/images/marker_shadow.png",
                    
                    // Makes sure the background graphic is placed correctly relative
                    // to the external graphic.
                    backgroundXOffset: 0,
                    backgroundYOffset: -7,
                    
                    // Set the z-indexes of both graphics to make sure the background
                    // graphics stay in the background (shadows on top of markers looks
                    // odd; let's not do that).
                    graphicZIndex: MARKER_Z_INDEX,
                    backgroundGraphicZIndex: SHADOW_Z_INDEX,
                    
                    pointRadius: 10
                    }),
                  projection: new OpenLayers.Projection("EPSG:4326")
                }
          );

var controls = {
    point: new OpenLayers.Control.DrawFeature(newmarkers,
                OpenLayers.Handler.Point, {'featureAdded': onCompleteAdd}),
    drag: new OpenLayers.Control.DragFeature(newmarkers, {'onComplete': onCompleteMove}),
    selector: new OpenLayers.Control.SelectFeature(markers, { onSelect: createPopup, onUnselect: destroyPopup })
};

function createPopup(feature) {
  feature.popup = new OpenLayers.Popup.FramedCloud("pop",
      feature.geometry.getBounds().getCenterLonLat(),
      null,
      '<i>'+feature.attributes.description+'</i>',
      null,
      true,
      function() { controls['selector'].unselectAll(); }
  );
  map.addPopup(feature.popup);
}

function destroyPopup(feature) {
  feature.popup.destroy();
  feature.popup = null;
}

function addMarker() {
  controls['point'].activate();
  $('tClick').style.display = 'none';
  $('tMap').style.display = 'block';
}  

function onCompleteAdd(feature) {
  controls['selector'].deactivate();
  controls['point'].deactivate();
  controls['drag'].activate();
  
  if(feature) {
    geo = feature.geometry.clone();
    geo.transform(map.getProjectionObject(), map.displayProjection)
    $('lat').value = geo.y
    $('lon').value = geo.x
  }
  $('tMap').style.display = 'none';
  $('tMarker').style.display = 'block';
}

function onCompleteMove(feature) {
  if(feature) {
    geo = feature.geometry.clone();
    geo.transform(map.getProjectionObject(), map.displayProjection)
    $('lat').value = geo.y
    $('lon').value = geo.x
  }
}