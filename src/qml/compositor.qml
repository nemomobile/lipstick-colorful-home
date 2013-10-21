// Copyright (C) 2013 Jolla Ltd.
// Copyright (C) 2013 John Brooks <john.brooks@dereferenced.net>
//
// This file is part of colorful-home, a nice user experience for touchscreens.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import QtQuick 2.0
import org.nemomobile.lipstick 0.1

import "compositor"

Compositor {
    id: root

    property Item homeWindow

    // Set to the item of the current topmost window
    property Item topmostWindow

    // True if the home window is the topmost window
    homeActive: topmostWindow == root.homeWindow
    property bool appActive: !homeActive

    // The application window that was most recently topmost
    property Item topmostApplicationWindow

    function windowToFront(winId) {
        var o = root.windowForId(winId)
        var window = null

        if (o) window = o.userData
        if (window == null) window = homeWindow

        setCurrentWindow(window)
    }

    function setCurrentWindow(w, skipAnimation) {
        if (w == null)
            w = homeWindow

        topmostWindow = w;

        if (topmostWindow == homeWindow || topmostWindow == null) {
            clearKeyboardFocus()
        } else {
            if (topmostApplicationWindow) topmostApplicationWindow.visible = false
            topmostApplicationWindow = topmostWindow
            topmostApplicationWindow.visible = true
            if (!skipAnimation) topmostApplicationWindow.animateIn()
            w.window.takeFocus()
        }
    }

    Rectangle {
        id: layersParent
        anchors.fill: parent
        color: "black"

        Item {
            id: homeLayer
            z: root.homeActive ? 4 : 1
            anchors.fill: parent
        }

        Item {
            id: appLayer
            z: 2

            width: parent.width
            height: parent.height
            visible: root.appActive
        }

        Item {
            id: overlayLayer
            z: 5

            visible: root.appActive
        }

        Item {
            id: lockScreenLayer
            z: 6
            width: parent.width
            height: parent.height
        }

        Item {
            id: notificationLayer
            z: 7
        }
    }

    ScreenGestureArea {
        id: gestureArea
        z: 2
        anchors.fill: parent
        enabled: root.appActive

        property real swipeThreshold: 0.15

        onGestureStarted: {
            swipeAnimation.stop()
            cancelAnimation.stop()
            state = "swipe"
        }

        onGestureFinished: {
            if (gestureArea.progress >= swipeThreshold) {
                swipeAnimation.valueTo = inverted ? -max : max
                swipeAnimation.start()
            } else {
                cancelAnimation.start()
            }
        }

        states: [
            State {
                name: "swipe"

                PropertyChanges {
                    target: gestureArea
                    delayReset: true
                }

                PropertyChanges {
                    target: appLayer
                    x: gestureArea.horizontal ? gestureArea.value : 0
                    y: gestureArea.horizontal ? 0 : gestureArea.value
                }

                PropertyChanges {
                    target: homeLayer
                    opacity: 0.6 + 0.4 * gestureArea.progress
                    scale: 0.8 + 0.2 * gestureArea.progress
                }
            }
        ]

        SequentialAnimation {
            id: cancelAnimation

            NumberAnimation {
                target: gestureArea
                property: "value"
                to: 0
                duration: 200
                easing.type: Easing.OutQuint
            }

            PropertyAction {
                target: gestureArea
                property: "state"
                value: ""
            }
        }

        SequentialAnimation {
            id: swipeAnimation

            property alias valueTo: valueAnimation.to

            NumberAnimation {
                id: valueAnimation
                target: gestureArea
                property: "value"
                duration: 200
                easing.type: Easing.OutQuint
            }

            ScriptAction {
                script: setCurrentWindow(root.homeWindow)
            }

            PropertyAction {
                target: gestureArea
                property: "state"
                value: ""
            }
        }
    }

    Component {
        id: windowWrapper
        WindowWrapperBase { }
    }

    Component {
        id: alphaWrapper
        WindowWrapperAlpha { }
    }

    onWindowAdded: {
        if (debug) console.log("Compositor: Window added \"" + window.title + "\"")

        var isHomeWindow = window.isInProcess && root.homeWindow == null && window.title == "Home"
        var isNotificationWindow = window.category == "notification"
        var isOverlayWindow =  window.category == "overlay"
        var isLockScreen = window.category == "lockscreen"

        var parent = null
        if (isHomeWindow) {
            parent = homeLayer
        } else if (isNotificationWindow) {
            parent = notificationLayer
        } else if (isOverlayWindow){
            parent = overlayLayer
        } else if (isLockScreen) {
            parent = lockScreenLayer
        } else {
            parent = appLayer
        }

        var w;
        if (isOverlayWindow) w = alphaWrapper.createObject(parent, { window: window })
        else w = windowWrapper.createObject(parent, { window: window })

        window.userData = w

        if (isHomeWindow) {
            root.homeWindow = w
            setCurrentWindow(homeWindow)
        } else if (!isNotificationWindow && !isOverlayWindow && !isLockScreen) {
            setCurrentWindow(w)
        }
    }

    onWindowRemoved: {
        if (debug) console.log("Compositor: Window removed \"" + window.title + "\"")

        var w = window.userData;

        if (root.topmostWindow == w)
            setCurrentWindow(root.homeWindow);

        if (window.userData)
            window.userData.destroy()
    }
} 
