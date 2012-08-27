
# Main project file for Colorful Home

TEMPLATE = app
TARGET = colorful-home
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

CONFIG += qt link_pkgconfig
QT += network svg dbus xml declarative opengl

HEADERS +=

SOURCES += \
    main.cpp

RESOURCES += \
    resources-qml.qrc \
    resources-images.qrc

PKGCONFIG += lipstick

OTHER_FILES += \
    qml/pages/AppLauncher.qml \
    qml/pages/AppSwitcher.qml \
    qml/pages/AppSwitcher/SwitcherItem.qml \
    qml/components/Pager.qml \
    qml/components/TabBar.qml \
    qml/MainScreen.qml \
    qml/components/Lockscreen.qml \
    qml/pages/AppSwitcher/CloseButton.qml \
    qml/pages/AppLauncher/LauncherItem.qml \
    qml/pages/Search.qml \
    qml/pages/Cloud.qml \
    qml/pages/Favorites.qml
