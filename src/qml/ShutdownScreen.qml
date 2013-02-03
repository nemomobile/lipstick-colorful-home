import QtQuick 1.1
import org.nemomobile.lipstick 0.1
import com.nokia.meego 1.0

Item {
    id: shutdownWindow
    width: initialSize.width
    height: initialSize.height

    Image {
        property bool shouldBeVisible
        id: shutdownImage
        objectName: "shutdownImage"
        width: shutdownWindow.height
        height: shutdownWindow.width
        transform: Rotation {
            origin.x: shutdownWindow.height / 2
            origin.y: shutdownWindow.height / 2
            angle: -90
        }
        opacity: shouldBeVisible ? 1 : 0

        source: "image://theme/graphic-shutdown-480x854"

        Connections {
            target: shutdownScreen
            onWindowVisibleChanged: if (shutdownScreen.windowVisible) { shutdownImage.shouldBeVisible = true }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
                onRunningChanged: if (!running && shutdownImage.opacity == 0) shutdownScreen.windowVisible = false
            }
        }
    }
}
