
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
import org.nemomobile.lipstick 0.1
import "./AppLauncher"

// App Launcher page
// the place for browsing installed applications and launching them

Item {
    id: launcherRoot

    property alias cellWidth: gridview.cellWidth

    GridView {
        id: gridview
        width: Math.floor(parent.width / cellWidth) * cellWidth
        cellWidth: 80 + 60
        cellHeight: cellWidth
        cacheBuffer: 40
        anchors {
            top: parent.top;
            bottom: parent.bottom;
            horizontalCenter: parent.horizontalCenter;
            topMargin: 30
            bottomMargin: 20
        }

        model: LauncherModel { }

        delegate: LauncherItem {
            id: launcherItem
            width: gridview.cellWidth
            height: gridview.cellHeight
            iconFilePath: model.object.iconFilePath === "" ? ":/images/icons/apps.png" : model.object.iconFilePath
            iconCaption: model.object.title
            onClicked: model.object.launchApplication();
        }
    }
}
