import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: "Surveillance Logs"
    id: root
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: "#0B1C2C"  // Match main background

        Column {
            anchors.fill: parent
            spacing: 8
            padding: 12

            // === Top Navigation Bar (copied from Main.qml) ===
            Rectangle {
                width: parent.width
                height: 50
                color: Qt.rgba(0x1B / 255, 0x3A / 255, 0x50 / 255, 0.3)
                radius: 8

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 20

                    Label {
                        text: "Telemetry Logs"
                        font.bold: true
                        font.pixelSize: 22
                        color: "#FFFFFF"
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    // --- Surveillance Logs Tab (highlighted) ---
                    Rectangle {
                        width: 180
                        height: 36
                        radius: 6
                        color: "#2A4C6B"

                        Label {
                            anchors.centerIn: parent
                            text: "Video Feeds"
                            font.pixelSize: 20
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.color = "#2A4C6B"
                            onExited: parent.color = "transparent"
                            onClicked: {
                                console.log("Navigating to Video Feeds page")
                                dynamicLoader.source = "Main.qml"
                            }
                        }
                    }

                    // --- Map View Tab ---
                    Rectangle {
                        width: 120
                        height: 36
                        radius: 6
                        color: "transparent"

                        Label {
                            anchors.centerIn: parent
                            text: "Map View"
                            font.pixelSize: 20
                            color: "#FFFFFF"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: parent.color = "#2A4C6B"
                            onExited: parent.color = "transparent"
                            onClicked: {
                                console.log("Navigating to Map View page")
                                dynamicLoader.source = "MapView.qml"
                            }
                        }
                    }
                }
            }

            // === Telemetry Header ===
            Text {
                text: "Telemetry Data"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // === Telemetry List ===
            Rectangle {
                width: parent.width
                height: parent.height - 140
                color: "#1B3A50"
                border.color: "#3B82F6"
                radius: 8

                ListView {
                    id: telemetryList
                    anchors.fill: parent
                    model: telemetryModel
                    clip: true

                    delegate: Rectangle {
                        width: parent.width
                        height: 40
                        color: index % 2 === 0 ? "#1F2F40" : "#233B50"
                        border.color: "#3B82F6"

                        Row {
                            spacing: 10
                            anchors.verticalCenter: parent.verticalCenter
                            padding: 6

                            Text { text: timestamp; width: 120; color: "white" }
                            Text { text: object; width: 80; color: "white" }
                            Text { text: targetLat.toFixed(5); width: 100; color: "white" }
                            Text { text: targetLon.toFixed(5); width: 100; color: "white" }
                            Text { text: droneLat.toFixed(5); width: 100; color: "white" }
                            Text { text: droneLon.toFixed(5); width: 100; color: "white" }
                            Text { text: altitude.toFixed(1); width: 80; color: "white" }
                            Text { text: yaw.toFixed(1); width: 60; color: "white" }
                        }
                    }
                }
            }
        }
    }
}
