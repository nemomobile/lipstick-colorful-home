import QtQuick 2.0
import org.nemomobile.lipstick 0.1
//import org.freedesktop.contextkit 1.0
import com.nokia.meego 2.0
import QtQuick.Window 2.1

Item {
    property bool isPortrait: (orientationAngle == 90 || orientationAngle == 270)
    id: usbWindow
    width: initialSize.width
    height: initialSize.height

    property int orientationAngle : Screen.angleBetween(Screen.primaryOrientation,Screen.orientation)
    onOrientationAngleChanged: {
        console.debug("Changed to Value: "+orientationAngle)
    }

    Item {
        property bool shouldBeVisible
        id: usbDialog
        width: usbWindow.isPortrait ? usbWindow.height : usbWindow.width
        height: usbWindow.isPortrait ? usbWindow.width : usbWindow.height
        transform: Rotation {
            origin.x: { switch(orientationAngle) {
                      case 180:
                      case 270:
                          return usbWindow.width / 2
                      case 90:
                          return usbWindow.height / 2
                      default:
                          return 0
                      } }
            origin.y: { switch(orientationAngle) {
                case 270:
                    return usbWindow.width / 2
                case 180:
                case 90:
                    return usbWindow.height / 2
                default:
                    return 0
                } }
            angle: {
                switch (orientationAngle) {
                    case undefined:
                    case 0:
                        return 0;
                    case 180:
                        return -180;
                    case 90:
                        return -90;
                    case 270:
                        return 90;
                }
            }
        }
        opacity: shouldBeVisible ? 1 : 0

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.8
        }

        MouseArea {
            id: usbDialogBackground
            anchors.fill: parent

            onClicked: { usbModeSelector.setUSBMode(4); usbDialog.shouldBeVisible = false }

            Rectangle {
                id: chargingOnly
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    topMargin: parent.height / 4
                }
                height: 102
                color: "black"
                radius: 5
                border {
                    color: "gray"
                    width: 2
                }

                Text {
                    anchors {
                        fill: parent
                    }
                    text: "Current mode: Charging only"
                    color: "white"
                    font.pixelSize: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Text {
                id: button1
                anchors {
                    top: chargingOnly.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: "MTP Mode"
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(11); usbDialog.shouldBeVisible = false }
                }
            }

            Text {
                id: button2
                anchors {
                    top: button1.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: "Mass Storage Mode"
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(3); usbDialog.shouldBeVisible = false }
                }
            }

            Text {
                id: button3
                anchors {
                    top: button2.bottom
                    topMargin: 40
                    left: parent.left
                    right: parent.right
                }
                text: "Developer Mode"
                color: "white"
                font.pixelSize: 30
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { usbModeSelector.setUSBMode(10); usbDialog.shouldBeVisible = false }
                }
            }
        }

        Connections {
            target: usbModeSelector
            onWindowVisibleChanged: if (usbModeSelector.windowVisible) usbDialog.shouldBeVisible = true
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                onRunningChanged: if (!running && usbDialog.opacity == 0) usbModeSelector.windowVisible = false
            }
        }
    }
}
