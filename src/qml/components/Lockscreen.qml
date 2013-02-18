import QtQuick 1.1

import org.nemomobile.time 1.0

Image {
    id: lockScreen
    source: "file://" + wallpaperSource.value
    property bool animating: y != 0 && y != -height
    property bool heightIsChanging: false

    onHeightChanged: {
        /* Fixes: https://bugs.nemomobile.org/show_bug.cgi?id=521 */

        if (animating) {
            return;
        }

        heightIsChanging = true;
        if (LipstickSettings.lockscreenVisible) {
            show();
        } else {
            hide();
        }
        heightIsChanging = false;
    }

    function hide() {
        y = -height
    }

    function show() {
        y = 0
    }

    // can't use a binding, as we also assign y based on mousearea below
    Connections {
        target: LipstickSettings
        onLockscreenVisibleChanged: {
            if (LipstickSettings.lockscreenVisible)
                lockScreen.show()
            else
                lockScreen.hide()
        }
    }

    Behavior on y {
        id: yBehavior
        enabled: !mouseArea.fingerDown && !heightIsChanging
        PropertyAnimation {
            properties: "y"
            easing.type: Easing.OutBounce
            duration: 400
        }
    }

    MouseArea {
        id: mouseArea
        property int pressY: 0
        property bool fingerDown
        property bool ignoreEvents
        anchors.fill: parent

        onPressed: {
            // ignore a press when we're already animating
            // this can cause jitter in the lockscreen, which
            // isn't really nice
            if (lockScreen.animating) {
                ignoreEvents = true
                return
            }

            fingerDown = true
            pressY = mouseY
        }

        onPositionChanged: {
            if (ignoreEvents)
                return

            var delta = pressY - mouseY
            pressY = mouseY + delta
            if (parent.y - delta > 0)
                return
            parent.y = parent.y - delta
        }

        onReleased: {
            if (ignoreEvents) {
                ignoreEvents = false
                return
            }

            fingerDown = false
            if (!LipstickSettings.lockscreenVisible || Math.abs(parent.y) > parent.height / 3) {
                LipstickSettings.lockscreenVisible = false

                // we must explicitly also set height, and
                // not rely on the connection for the corner-case
                // where the user drags the lockscreen while it's
                // animating up.
                lockScreen.hide()
            } else if (LipstickSettings.lockscreenVisible) {
                lockScreen.show()
            }
        }
    }

    WallClock {
        id: wallClock
        enabled: LipstickSettings.lockscreenVisible
        updateFrequency: WallClock.Minute
    }

    Text {
        id: timeDisplay
        font.pixelSize: 130
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        width: parent.width

        text: Qt.formatDateTime(wallClock.time, "hh:mm")
    }

    Text {
        id: dateDisplay
        horizontalAlignment: Text.AlignHCenter
        anchors.top: timeDisplay.bottom
        color: "white"
        font.pixelSize: 50
        width: parent.width

        text: Qt.formatDateTime(wallClock.time, "dd/MM/yyyy")
    }
}

