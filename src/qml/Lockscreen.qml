import QtQuick 2.0
import org.nemomobile.lipstick 0.1

HomeWindow {
    id: window
    category: "lockscreen"

    property alias width: lockScreen.width
    property alias height: lockScreen.height
    property alias openingState: lockScreen.openingState

    Component.onCompleted: {
        window.visible = true
    }

    rootObject: Image {
        id: lockScreen
        source: "file://" + wallpaperSource.value
        y: -height

        Rectangle {
            color: "red"
            anchors.fill: parent
        }

        /**
        * openingState should be a value between 0 and 1, where 0 means
        * the lockscreen is "down" (obscures the view) and 1 means the
        * lockscreen is "up" (not visible).
        **/
        property real openingState: height > 0 ? y / -height : 1
        visible: openingState < 1
        onHeightChanged: {
            if (mouseArea.fingerDown)
                return // we'll fix this up on touch release via the animations

            if (snapOpenAnimation.running)
                snapOpenAnimation.to = -height
            else if (!snapClosedAnimation.running && !LipstickSettings.lockscreenVisible)
                y = -height
        }

        function snapPosition() {
            if (LipstickSettings.lockscreenVisible) {
                snapOpenAnimation.stop()
                snapClosedAnimation.start()
            } else {
                snapClosedAnimation.stop()
                snapOpenAnimation.start()
            }
        }

        function cancelSnap() {
            snapClosedAnimation.stop()
            snapOpenAnimation.stop()
        }

        Connections {
            target: LipstickSettings
            onLockscreenVisibleChanged: lockScreen.snapPosition()
        }

        PropertyAnimation {
            id: snapClosedAnimation
            target: lockScreen
            property: "y"
            to: 0
            easing.type: Easing.OutBounce
            duration: 400
        }

        PropertyAnimation {
            id: snapOpenAnimation
            target: lockScreen
            property: "y"
            to: -height
            easing.type: Easing.OutExpo
            duration: 400
        }

        MouseArea {
            id: mouseArea
            property int pressY: 0
            property bool fingerDown
            property bool ignoreEvents
            anchors.fill: parent

            onPressed: {
                fingerDown = true
                lockScreen.cancelSnap()
                pressY = mouseY
            }

            onPositionChanged: {
                var delta = pressY - mouseY
                pressY = mouseY + delta
                if (parent.y - delta > 0)
                    return
                parent.y = parent.y - delta
            }

            function snapBack() {
                fingerDown = false
                if (!LipstickSettings.lockscreenVisible || Math.abs(parent.y) > parent.height / 3) {
                    LipstickSettings.lockscreenVisible = false
                } else if (LipstickSettings.lockscreenVisible) {
                    LipstickSettings.lockscreenVisible = true
                }

                lockScreen.snapPosition()
            }

            onCanceled: snapBack()
            onReleased: snapBack()
        }

        LockscreenClock {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }
    }
}

