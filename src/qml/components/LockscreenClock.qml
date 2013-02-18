
import QtQuick 1.1
import org.nemomobile.time 1.0

Rectangle {
    id: lockscreenClock
    property int spacing: 35

    height: timeDisplay.height + dateDisplay.height + 3.9 * spacing

    gradient: Gradient {
        GradientStop { position: 0.0; color: '#dd000000' }
        GradientStop { position: 0.5; color: '#aa000000' }
        GradientStop { position: 1.0; color: '#00000000' }
    }

    WallClock {
        id: wallClock
        enabled: LipstickSettings.lockscreenVisible
        updateFrequency: WallClock.Minute
    }

    Column {
        id: clockColumn

        anchors {
            margins: parent.spacing
            left: parent.left
            right: parent.right
            top: parent.top
        }

        Text {
            id: timeDisplay

            font.pixelSize: 120
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignRight

            anchors {
                left: parent.left
                right: parent.right
                rightMargin: -5
            }

            text: Qt.formatDateTime(wallClock.time, "hh:mm")
        }

        Text {
            id: dateDisplay

            font.pixelSize: 30
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignRight

            anchors {
                left: parent.left
                right: parent.right
            }

            text: Qt.formatDateTime(wallClock.time, "dd/MM/yyyy")
        }
    }
}

