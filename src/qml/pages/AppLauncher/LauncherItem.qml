
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

MouseArea {
    property alias source: iconImage.source
    property alias iconCaption: iconText.text

    // Application icon for the launcher
    Image {
        id: iconImage
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 8
        }
        width: 80
        height: width
        asynchronous: true
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Error loading an app icon, falling back to default.");
                iconImage.source = ":/images/icons/apps.png";
            }
        }

        SequentialAnimation {
            id: launchAnimation
            running: model.object.isLaunching
            loops: Animation.Infinite
            alwaysRunToEnd: true

            NumberAnimation {
                target: iconImage
                property: "scale"
                to: 0.6
                duration: 700
            }

            NumberAnimation {
                target: iconImage
                property: "scale"
                to: 1
                duration: 700
            }
        }
    }

    // Caption for the icon
    Text {
        id: iconText
        // elide only works if an explicit width is set
        width: parent.width
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        color: 'white'
        anchors {
            left: parent.left
            right: parent.right
            top: iconImage.bottom
            topMargin: 5
        }
    }
}
