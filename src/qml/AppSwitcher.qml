
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
import com.nokia.meego 1.2

// App Switcher page
// The place for browsing already running apps

Item {
    id: switcherRoot
    property bool closeMode: false
    property bool visibleInHome: false
    property alias runningAppsCount: switcherModel.itemCount

    onVisibleInHomeChanged: {
        // Exit close mode when scrolling out of view
        if (!visibleInHome && closeMode) {
            closeMode = false;
        }
    }

    Flickable {
        id: flickable
        contentHeight: gridview.height
        width: parent.width - UiConstants.DefaultMargin // see comment re right anchor below

        MouseArea {
            height: flickable.contentHeight > flickable.height ? flickable.contentHeight : flickable.height
            width: flickable.width
            onPressAndHold: closeMode = !closeMode
            onClicked: {
                if (closeMode)
                    closeMode = false
            }
        }

        anchors {
            top: parent.top
            bottom: toolBar.top
            left: parent.left
            // no right anchor to avoid double margin (complicated math)
            margins: UiConstants.DefaultMargin
        }

        Grid {
            id: gridview
            columns: 2
            spacing: UiConstants.DefaultMargin
            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                }
            }

            Repeater {
                model: SwitcherModel {
                    id:switcherModel
                }

                delegate: Item {
                    width: (flickable.width - (gridview.spacing * gridview.columns)) / gridview.columns
                    height: width * (desktop.height / desktop.width)

                    SwitcherItem {
                        width: parent.width
                        height: parent.height
                    }
                }
            }
        }
    }

    Rectangle {
        id: toolBar
        color: 'black'
        border {
            width: 1
            color: '#333333'
        }

        height: toolBarDone.height + 2*padding
        property int padding: 9

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: -1
            bottomMargin: switcherRoot.closeMode ? 0 : -height
        }

        Behavior on anchors.bottomMargin { PropertyAnimation { duration: 100 } }

        Button {
            id: toolBarDone
            width: parent.width / 3
            anchors {
                top: parent.top
                topMargin: toolBar.padding
                right: parent.horizontalCenter
                rightMargin: toolBar.padding
            }
            text: 'Done'
            onClicked: {
                switcherRoot.closeMode = false;
            }
        }

        Button {
            id: toolBarCloseAll
            width: toolBarDone.width
            anchors {
                top: parent.top
                topMargin: toolBar.padding
                left: parent.horizontalCenter
                leftMargin: toolBar.padding
            }
            text: 'Close all'
            onClicked: {
                // TODO: use close animation inside item
                for (var i=switcherModel.itemCount-1; i>=0; i--) {
                    windowManager.closeWindow(switcherModel.get(i).window);
                }
            }
        }
    }

    // Empty switcher indicator
    ViewPlaceholder {
        enabled: switcherModel.itemCount === 0
        onEnabledChanged: {
            /* When the last window is closed, exit close mode */
            if (visible) {
                switcherRoot.closeMode = false;
            }
        }
        text: "No apps open"
    }
}
