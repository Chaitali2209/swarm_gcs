import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtMultimedia 6.2

Window {
    visible: true
    width: 1400
    height: 900
    title: "Rapid Surveillance System"

    property var rtspUrls: [
        "rtsp://192.168.0.130:8554/stream4",
        "rtsp://192.168.0.130:8554/stream4",
        "rtsp://192.168.0.130:8554/stream3",
        "rtsp://192.168.0.130:8554/stream4"
    ]

    property bool isGridView: true

    StackLayout {
        id: layoutSwitcher
        anchors.fill: parent
        currentIndex: isGridView ? 0 : 1

        // --- GRID VIEW ---
        Item {
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 20

                Label {
                    text: "Rapid Surveillance System"
                    font.pixelSize: 32
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                    color: black
                }

                GridLayout {
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        model: 4
                        delegate: Rectangle {
                            id: videoContainer
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "white"
                            radius: 16
                            border.color: "grey"
                            border.width: 1
                            // clip: true  // Important to enforce rounded corners on child items
                            // layer.enabled: true

                            VideoOutput {
                                id: gridVideoOutput
                                anchors.fill: videoContainer
                                fillMode: VideoOutput.Stretch  // Makes video fill entire area
                                z: 0
                            }

                            Label {
                                text: "Stream " + (index + 1)
                                color: "black"
                                font.pixelSize: 16
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                anchors.margins: 8
                                z: 1
                                background: Rectangle {
                                    color: "white"
                                    radius: 4
                                    opacity: 0.5
                                }
                            }

                            MediaPlayer {
                                id: gridMediaPlayer
                                autoPlay: true
                                source: rtspUrls[index]
                                videoOutput: gridVideoOutput
                            }
                        }
                                           }
                                   }

            }
        }

        // --- FULLSCREEN SWIPE VIEW ---
        SwipeView {
            id: swipeFeeds
            anchors.fill: parent
            currentIndex: 0

            Repeater {
                model: 4
                delegate: Item {
                    width: swipeFeeds.width
                    height: swipeFeeds.height

                    VideoOutput {
                        id: fullscreenOutput
                        anchors.fill: parent
                        fillMode: VideoOutput.Stretch // Fills entire window
                    }

                    MediaPlayer {
                        id: fullscreenPlayer
                        autoPlay: true
                        source: rtspUrls[index]
                        videoOutput: fullscreenOutput
                    }

                    Label {
                        text: "Drone Feed " + (index + 1)
                        font.pixelSize: 24
                        color: "black"
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 16
                        z: 1
                    }
                }
            }
        }
    }

    // --- Floating Button to Toggle Views ---
    Rectangle {
        id: toggleButton
        width: 56
        height: 56
        radius: 28
        color: "#2196F3"
        border.color: "white"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 24
        z: 100

        Text {
            anchors.centerIn: parent
            text: isGridView ? "➤" : "⤺"
            color: "white"
            font.pixelSize: 24
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                isGridView = !isGridView
            }
        }
    }
}
