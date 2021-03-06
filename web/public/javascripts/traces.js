
function getTraces(mode) {
  if(mode) {
    url = '/trace/traces.kml?mode='+mode
  } else {
    url = '/trace/traces.kml'
  }

  layer = new OpenLayers.Layer.Vector("All Traces",
            { protocol: new OpenLayers.Protocol.HTTP({
              url: url,
              format: new OpenLayers.Format.KML({extractStyles: false, extractAttributes: true})
            }),
            strategies: [new OpenLayers.Strategy.BBOX()],
            projection: new OpenLayers.Projection("EPSG:4326"),
            styleMap: new OpenLayers.StyleMap({strokeWidth: 4, strokeColor: '#0000ff', strokeOpacity: 0.4, pointRadius: 5, fillColor: '#ff00ff', fillOpacity: 0.4}),
            minScale: 100000
            });
  return layer;
}