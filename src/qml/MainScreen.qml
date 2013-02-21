
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

/**
 * Dirty Hack Alarm!

 * In order for lipstick's StatusBar to win over Harmattan Qt Components's
 * StatusBar, we need to import com.nokia.meego first. If the order is
 * wrong, you might see "StatusBar doesn't have an isPortrait property".
 *
 * Therefore: com.nokia.meego must be imported before org.nemomobile.lipstick
 **/
import com.nokia.meego 1.0
import org.nemomobile.lipstick 0.1

import org.nemomobile.configuration 1.0
import org.nemomobile.time 1.0

import "./components"
import "./pages"

// The item representing the main screen; size is constant
PageStackWindow {
    id: mainScreen

    showStatusBar: !LipstickSettings.lockscreenVisible

    // This is used in the favorites page and in the lock screen
    WallClock {
        id: wallClock
        enabled: true /* XXX: Disable when display is off */
        updateFrequency: WallClock.Minute
    }

    // This is used in the lock screen
    ConfigurationValue {
        id: wallpaperSource
        key: desktop.isPortrait ? "/desktop/meego/background/portrait/picture_filename" : "/desktop/meego/background/landscape/picture_filename"
        defaultValue: "images/graphics-wallpaper-home.jpg"
    }

    initialPage: Page {
        Item {
            id: desktop
            property bool isPortrait: width < height

            anchors.fill: parent

            // Pager for swiping between different pages of the home screen
            Pager {
                id: pager
                anchors.fill: parent

                model: VisualItemModel {
                    Favorites {
                        id: favorites
                        width: pager.width
                        height: pager.height
                    }
                    AppLauncher {
                        id: launcher
                        height: pager.height
                    }
                    AppSwitcher {
                        id: switcher
                        width: pager.width
                        height: pager.height
                        columnNumber: 2
                    }
                }
            }

            /**
             * Non-visual, needed to set _MEEGOTOUCH_ORIENTATION_ANGLE, because
             * otherwise qt-components' setting of this XAtom conflicts with
             * lipstick's handling of the status bar.
             *
             * This is org.nemomobile.lipstick.StatusBar (see above for details)
             **/
            StatusBar {
                isPortrait: desktop.isPortrait
            }

            Lockscreen {
                width: parent.width
                height: parent.height

                z: 200
            }
        }
    }

    Component.onCompleted: {
        theme.inverted = true;
    }
}
