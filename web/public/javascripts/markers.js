var emotionIcons = {
  "happy": {externalGraphic: "/images/positive.png"},
  "neutral": {externalGraphic: "/images/neutral.png"},
  "sad": {externalGraphic: "/images/negative.png"}
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

var markers = new OpenLayers.Layer.Vector("All Markers",
                { protocol: new OpenLayers.Protocol.HTTP({
                    url: '/marker/all.kml',
                    format: new OpenLayers.Format.KML({extractStyles: false, extractAttributes: true}),
                  }),
                  strategies: [new OpenLayers.Strategy.BBOX()],
                  projection: new OpenLayers.Projection("EPSG:4326"),
                  styleMap: markerStyle,
                  minScale: 100000
                });

var newmarkers = new OpenLayers.Layer.Vector("New Markers", 
                { styleMap: new OpenLayers.StyleMap({
                    // Set the external graphic and background graphic images.
                    externalGraphic: "/images/active.png",
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
      '<div class="markerContent">'+feature.attributes.description+'</div>',
      null,
      true,
      function() { controls['selector'].unselectAll(); }
  );
  //feature.popup.closeOnMove = true;
  map.addPopup(feature.popup);
}

function destroyPopup(feature) {
  feature.popup.destroy();
  feature.popup = null;
}

function addMarker() {
  controls['point'].activate();
  $('tMap').show();
}  

function onCompleteAdd(feature) {
  controls['selector'].deactivate();
  controls['point'].deactivate();
  controls['drag'].activate();
  $('tMap').hide();
  $('tMarker').show();
  $('marker_form').show();
  
  //feature.attributes.description = "w00t";
  //createPopup(feature);
  
  if(feature) {
    geo = feature.geometry.clone();
    geo.transform(map.getProjectionObject(), map.displayProjection)
    $('lat').value = geo.y
    $('lon').value = geo.x
  }

}

function onCompleteMove(feature) {
  if(feature) {
    geo = feature.geometry.clone();
    geo.transform(map.getProjectionObject(), map.displayProjection)
    $('lat').value = geo.y
    $('lon').value = geo.x
  }
}