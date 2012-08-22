
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
// Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>

import QtQuick 1.1

Rectangle {
    signal clicked()

    id: closeButton
    width: 54
    height: 54
    radius: 27
    color: 'red'

    Rectangle {
        color: 'white'
        anchors.centerIn: parent
        width: 40
        height: 40
        radius: 20

        Rectangle {
            anchors.centerIn: parent
            color: 'red'
            width: 34
            height: 8
            transform: Rotation {
                angle: 45
                origin.x: 17
                origin.y: 4
            }
        }
        Rectangle {
            anchors.centerIn: parent
            color: 'red'
            width: 34
            height: 8
            transform: Rotation {
                angle: -45
                origin.x: 17
                origin.y: 4
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: closeButton.clicked()
    }
}
