import QtQuick 1.1

Image {
    id: lockScreen
    source: "file://" + wallpaperSource.value
    property bool animating: y != parent.y && y != parent.y-height
    property bool heightIsChanging: false

    /**
     * openingState should be a value between 0 and 1, where 0 means
     * the lockscreen is "down" (obscures the view) and 1 means the
     * lockscreen is "up" (not visible).
     **/
    property real openingState: (parent.y - y) / height

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
        y = parent.y-height
    }

    function show() {
        y = parent.y
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

    LockscreenClock {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }
}

