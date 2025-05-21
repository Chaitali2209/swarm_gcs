import QtQuick 2.15
import QtQuick.Controls 2.15
import QtLocation 6.5
import QtPositioning 6.5

Item {
    width: 1400
    height: 900

    property string bingKey: "efieWV1CL9zbroec5Jp7~hZR7qjtTjRZj4DE0reC56g~AhqGtSPRjTNhw-jck1qYbypHmIeXoWaNpQHF36c86gClzKIPoWMKeyIJ8sf8V7hZ"

    Map {
        id: mapView
        anchors.fill: parent
        plugin: Plugin { name: "osm" }
        center: QtPositioning.coordinate(19.1334, 72.9133)
        zoomLevel: 16

        // Dynamically load tiles
        Repeater {
            id: tileRepeater
            model: []

            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(model.lat, model.lon)
                anchorPoint.x: 0
                anchorPoint.y: 0
                zoomLevel: model.zoom
                sourceItem: Image {
                    width: 256
                    height: 256
                    source: model.url
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Component.onCompleted: {
            generateTiles()
        }

        function generateTiles() {
            let tileSize = 256;
            let zoom = Math.floor(mapView.zoomLevel);
            let bounds = mapView.visibleRegion.boundingRectangle;
            let topLeft = bounds.topLeft;
            let bottomRight = bounds.bottomRight;

            tileRepeater.model = [];

            for (let x = 0; x < 4; x++) {
                for (let y = 0; y < 4; y++) {
                    let lat = mapView.center.latitude + (y - 2) * 0.01;
                    let lon = mapView.center.longitude + (x - 2) * 0.01;
                    let quadkey = latLonToQuadKey(lat, lon, zoom);
                    tileRepeater.model.push({
                        lat: lat,
                        lon: lon,
                        zoom: zoom,
                        url: "https://ecn.t3.tiles.virtualearth.net/tiles/a" + quadkey + ".jpeg?g=1&key=" + bingKey
                    });
                }
            }
        }

        function latLonToQuadKey(lat, lon, zoom) {
            let x = Math.floor((lon + 180) / 360 * Math.pow(2, zoom));
            let y = Math.floor((1 - Math.log(Math.tan(lat * Math.PI / 180) + 1 / Math.cos(lat * Math.PI / 180)) / Math.PI) / 2 * Math.pow(2, zoom));
            let quadKey = "";
            for (let i = zoom; i > 0; i--) {
                let digit = 0;
                let mask = 1 << (i - 1);
                if ((x & mask) !== 0) digit += 1;
                if ((y & mask) !== 0) digit += 2;
                quadKey += digit;
            }
            return quadKey;
        }
    }

    Button {
        text: "Back"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 16
        onClicked: dynamicLoader.source = ""
    }
}
