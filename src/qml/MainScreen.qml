
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
//
// Copyright (c) 2011, Tom Swindell <t.swindell@rubyx.co.uk>
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>

import QtQuick 1.1
import QtMobility.sensors 1.2
import org.nemomobile.lipstick 0.1
import "./components"
import "./pages"

Item {
    property bool isPortrait: false;

    id: mainScreen
    width: initialSize.width
    height: initialSize.height

//    OrientationSensor {
//        id: orientation
//        active: true

//        onReadingChanged: {
//            var orientationChanged = false;
//            var previousIndex = Math.round(dashboard.contentX / dashboard.width);

//            if (reading.orientation === OrientationReading.TopUp && !isPortrait) {
//                // The top of the device is upwards - meaning: portrait
//                isPortrait = true;
//                desktopRotation.angle = -90;
//                desktop.width = mainScreen.height;
//                desktop.height = mainScreen.width;
//                orientationChanged = true;
//            }
//            if (reading.orientation === OrientationReading.RightUp && isPortrait) {
//                // The right side of the device is upwards - meaning: landscape
//                isPortrait = false;
//                desktopRotation.angle = 0;
//                desktop.width = mainScreen.width;
//                desktop.height = mainScreen.height;
//                orientationChanged = true;
//            }

//            if (orientationChanged)
//                dashboard.contentX = previousIndex * dashboard.width;

//            console.log(launcher.width);
//            console.log(launcher.height);
//        }
//    }

    Item {
        property bool isPortrait : height > width

        id: desktop
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height
        transform: Rotation {
            id: desktopRotation;
            origin.x: mainScreen.height / 2;
            origin.y: mainScreen.height / 2;
            angle: 0
        }

        Image {
            id: background
            anchors.fill: parent
            source: ':/images/background.jpg'
            fillMode: Image.PreserveAspectFit
        }
        Rectangle {
            id:overlay
            anchors.fill:parent
            opacity:0.6
            color:'black'
        }
        Rectangle {
            color: 'black'
            anchors.fill: statusBar
        }
        StatusBar {
            id: statusBar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            isPortrait: mainScreen.isPortrait
        }

        AppLauncher {
            id: launcher
            width: desktop.width
            height: desktop.height
            anchors.centerIn: desktop
        }
    }
}
