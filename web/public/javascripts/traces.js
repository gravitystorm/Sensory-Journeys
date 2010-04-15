var traces = new OpenLayers.Layer.GML("traces", "/trace/traces.kml",
                {   format: OpenLayers.Format.KML,
                    projection: new OpenLayers.Projection("EPSG:4326"),
                    formatOptions: {
                      extractStyles: false,
                      extractAttributes: true,
                      maxDepth: 2
                    },
                  strategies: [new OpenLayers.Strategy.BBOX()],
                  projection: new OpenLayers.Projection("EPSG:4326"),
                  styleMap: new OpenLayers.StyleMap({ strokeWidth: 9, strokeColor: '#0000ff', strokeOpacity: 0.7 }),
                  minScale: 100000
                });
