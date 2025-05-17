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
    color: "#0B1C2C"


    // FontLoader {
    //     id: poppinsFont
    //     source: "qrc:/fonts/assets/Poppins-Regular.ttf"
    // }


    property var rtspUrls: [
        "rtsp://192.168.0.130:8554/stream1",
        "rtsp://192.168.0.130:8554/stream2",
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

                // Label {
                //     text: "Rapid Surveillance System"
                //     font.pixelSize: 32
                //     font.bold: true
                //     horizontalAlignment: Text.AlignHCenter
                //     Layout.alignment: Qt.AlignHCenter
                //     color: "#FFFFFF"
                //     font.family: poppinsFont.name
                // }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: Qt.rgba(0x1B / 255, 0x3A / 255, 0x50 / 255, 0.3)
                    radius: 8


                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 20

                        Label {
                            text: "Video Feed"
                            font.bold: true
                            font.pixelSize: 22
                            color: "#FFFFFF"
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item { Layout.fillWidth: true }

                        // --- Surveillance Logs Label Tab ---
                        Rectangle {
                            width: 180
                            height: 36
                            radius: 6
                            color: "transparent"
                            // border.color: "#3B82F6"

                            Label {
                                anchors.centerIn: parent
                                text: "Surveillance Logs"
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
                                    console.log("Navigating to Surveillance Logs page")
                                    // TODO: implement page switch
                                }
                            }
                        }

                        // --- Map View Label Tab ---
                        Rectangle {
                            width: 120
                            height: 36
                            radius: 6
                            color: "transparent"
                            // border.color: "#3B82F6"

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
                                    // TODO: implement page switch
                                }
                            }
                        }
                    }
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
                            border.color: "#3B82F6"
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

                    // Video container with rounded corners
                                Rectangle {
                                    id: roundedVideoContainer
                                    anchors.fill: parent
                                    radius: 20
                                    color: "#33F0F4F8"

                                    clip: true
                                    anchors.margins: 24


                                    VideoOutput {
                                        id: fullscreenOutput
                                        anchors.fill: parent
                                        fillMode: VideoOutput.Stretch
                                    }

                                    // Bottom-left tab showing drone name
                                                                   Rectangle {
                                                                       width: 180
                                                                       height: 40
                                                                       radius: 8
                                                                       color: "#F0F4F8"  // Light tab color
                                                                       opacity: 0.85
                                                                       anchors.left: parent.left
                                                                       anchors.bottom: parent.bottom
                                                                       anchors.margins: 16
                                                                       z: 2

                                                                       Label {
                                                                           anchors.centerIn: parent
                                                                           text: "Drone Feed " + (index + 1)
                                                                           font.pixelSize: 20
                                                                           color: "#1B3A50"
                                                                           font.bold: true
                                                                       }
                                                                   }
                                }

                    MediaPlayer {
                        id: fullscreenPlayer
                        autoPlay: true
                        source: rtspUrls[index]
                        videoOutput: fullscreenOutput
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
        color: "#1B3A50"
        border.color: "#3B82F6"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 24
        z: 100

        Image {
                id: toggleIcon
                anchors.centerIn: parent
                width: 32
                height: 32
                source: isGridView ? "qrc:/icons/assets/grid.png" : "qrc:/icons/assets/grid.png"
                fillMode: Image.PreserveAspectFit
            }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                isGridView = !isGridView
            }
        }
    }
}
