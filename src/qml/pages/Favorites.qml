
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

// Favorites page:
// the place for user-customizable content such as
// widgets, notifications, favorite apps, etc.

Item {
    property variant currentDate: new Date()

    // Day of week
    Text {
        id: displayDayOfWeek
        text: Qt.formatDateTime(currentDate, "dddd")
        font.pixelSize: 40
        color: "white"
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 30
            leftMargin: 20
        }
    }

    // Current date
    Text {
        id: displayCurrentDate
        text: Qt.formatDate(currentDate, Qt.SystemLocaleShortDate)
        font.pixelSize: 40
        color: "white"
        anchors {
            top: displayDayOfWeek.bottom
            left: parent.left
            topMargin: 5
            leftMargin: 20
        }
    }

    // Separator thingy
    Rectangle {
        height: 2
        color: "white"
        anchors {
            top: displayCurrentDate.bottom
            left: parent.left
            right: parent.right
            topMargin: 5
            leftMargin: 20
            rightMargin: 20
        }
    }


    Text {
        font.pixelSize: 30
        text: "TODO: implement me"
        anchors.centerIn: parent
    }
}
