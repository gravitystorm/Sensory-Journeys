
function getTraces(mode) {
  if(mode) {
    url = '/trace/traces.kml?mode='+mode
  } else {
    url = '/trace/traces.kml'
  }

  layer = new OpenLayers.Layer.Vector("traces",
            { protocol: new OpenLayers.Protocol.HTTP({
              url: url,
              format: new OpenLayers.Format.KML({extractStyles: false, extractAttributes: true}),
            }),
            strategies: [new OpenLayers.Strategy.BBOX()],
            projection: new OpenLayers.Projection("EPSG:4326"),
            styleMap: new OpenLayers.StyleMap({ strokeWidth: 4, strokeColor: '#0000ff', strokeOpacity: 0.3 }),
            minScale: 100000
            });
  return layer;
}