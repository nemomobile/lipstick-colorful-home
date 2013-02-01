import QtQuick 1.1
import org.nemomobile.lipstick 0.1
import org.freedesktop.contextkit 1.0
import com.nokia.meego 1.0

Item {
    property bool isPortrait: (orientationAngleContextProperty.value == 90 || orientationAngleContextProperty.value == 270)
    id: volumeWindow
    width: initialSize.width
    height: initialSize.height

    ContextProperty {
        id: orientationAngleContextProperty
        key: "/Screen/CurrentWindow/OrientationAngle"
    }

    Rectangle {
        property bool shouldBeVisible
        id: volumeBar
        width: volumeWindow.isPortrait ? volumeWindow.height : volumeWindow.width
        height: volumeWindow.isPortrait ? volumeWindow.width : volumeWindow.height
        transform: Rotation {
            origin.x: { switch(orientationAngleContextProperty.value) {
                      case 270:
                          return volumeWindow.height / 2
                      case 180:
                      case 90:
                          return volumeWindow.width / 2
                      default:
                          return 0
                      } }
            origin.y: { switch(orientationAngleContextProperty.value) {
                case 270:
                case 180:
                    return volumeWindow.height / 2
                case 90:
                    return volumeWindow.width / 2
                default:
                    return 0
                } }
            angle: (orientationAngleContextProperty.value === undefined || orientationAngleContextProperty.value == 0) ? 0 : -360 + orientationAngleContextProperty.value
        }
        color: "black"
        opacity: volumeBar.shouldBeVisible ? 0.85 : 0

        Rectangle {
            y: parent.height - height
            width: parent.width
            height: parent.height * volumeControl.volume / volumeControl.maximumVolume
            color: "red"
            opacity: 0.5
            Behavior on height { NumberAnimation { duration: 250 } }
        }

        Timer {
            id: volumeTimer
            interval: 1500
            onTriggered: volumeBar.shouldBeVisible = false
        }

        Connections {
            target: volumeControl
            onWindowVisibleChanged: if (volumeControl.windowVisible) { volumeTimer.restart(); volumeBar.shouldBeVisible = true }
            onVolumeChanged: if (volumeControl.windowVisible) volumeTimer.restart()
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                onRunningChanged: if (!running && volumeBar.opacity == 0) volumeControl.windowVisible = false
            }
        }

        Image {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 50
            }
            source: volumeControl.volume > 0 ? "image://theme/icon-m-toolbar-volume" : "image://theme/icon-m-common-volume-off"
        }
    }
}
