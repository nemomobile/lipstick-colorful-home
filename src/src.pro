
# Main project file for Colorful Home

TEMPLATE = app
TARGET = lipstick
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

CONFIG += qt link_pkgconfig
QT += network svg dbus xml declarative

HEADERS +=

SOURCES += \
    main.cpp

RESOURCES += \
    resources-qml.qrc \
    resources-images.qrc

PKGCONFIG += lipstick libsystemd-daemon

OTHER_FILES += qml/*.qml
