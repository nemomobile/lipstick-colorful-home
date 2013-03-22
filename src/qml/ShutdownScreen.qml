import QtQuick 1.1
import org.nemomobile.lipstick 0.1
import com.nokia.meego 1.0

Item {
    id: shutdownWindow
    width: initialSize.width
    height: initialSize.height

    Rectangle {
        property bool shouldBeVisible
        id: shutdownBackground
        objectName: "shutdownBackground"
        width: shutdownWindow.width
        height: shutdownWindow.height
        color: "white"
        opacity: shouldBeVisible ? 1 : 0

        Image {
            id: shutdownLogoImage
            anchors.centerIn: parent
            objectName: "shutdownLogoImage"

            source: "image://theme/graphic-shutdown-logo"
        }

        Image {
            id: shutdownDisclaimerImage
            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: UiConstants.DefaultMargin
                rightMargin: UiConstants.DefaultMargin
            }
            objectName: "shutdownDisclaimerImage"

            source: "image://theme/graphic-shutdown-disclaimer"
        }

        Connections {
            target: shutdownScreen
            onWindowVisibleChanged: if (shutdownScreen.windowVisible) { shutdownBackground.shouldBeVisible = true }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
                onRunningChanged: if (!running && shutdownBackground.opacity == 0) shutdownScreen.windowVisible = false
            }
        }
    }
}
