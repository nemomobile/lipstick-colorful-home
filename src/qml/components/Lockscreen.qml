import QtQuick 1.1

Image {
    id: lockScreen
    source: "file://" + wallpaperSource.value

    // can't use a binding, as we also assign y based on mousearea below
    Connections {
        target: LipstickSettings
        onLockscreenVisibleChanged: {
            if (LipstickSettings.lockscreenVisible)
                lockScreen.y = 0
            else
                lockScreen.y = -height
        }
    }

    Behavior on y {
        id: yBehavior
        PropertyAnimation {
            properties: "y"
            easing.type: Easing.OutBounce
            duration: 400
        }
    }

    MouseArea {
        property int pressY: 0
        anchors.fill: parent
        enabled: LipstickSettings.lockscreenVisible

        onPressed: {
            yBehavior.enabled = false
            pressY = mouseY
        }
        onPositionChanged: {
            var delta = pressY - mouseY
            pressY = mouseY + delta
            if (parent.y - delta > 0)
                return
            parent.y = parent.y - delta
        }
        onReleased: {
            yBehavior.enabled = true
            if (!LipstickSettings.lockscreenVisible || Math.abs(parent.y) > parent.height / 3) {
                LipstickSettings.lockscreenVisible = false

                // we must explicitly also set height, and
                // not rely on the connection for the corner-case
                // where the user drags the lockscreen while it's
                // animating up.
                lockScreen.y = -height
            } else if (LipstickSettings.lockscreenVisible) {
                lockScreen.y = 0
            }
        }
    }

    Text {
        id: time
        text: Qt.formatDateTime(new Date(), "hh:mm")
        font.pixelSize: 130
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        width: parent.width
    }

    Text {
        horizontalAlignment: Text.AlignHCenter
        anchors.top: time.bottom
        text: Qt.formatDateTime(new Date(), "dd/MM/yyyy")
        color: "white"
        font.pixelSize: 50
        width: parent.width
    }
}

