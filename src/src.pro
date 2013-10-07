
# Main project file for Colorful Home

TEMPLATE = app
TARGET = lipstick
VERSION = 0.1

INSTALLS = target
target.path = /usr/bin

CONFIG += qt link_pkgconfig
QT += quick

HEADERS +=

SOURCES += \
    main.cpp

RESOURCES += \
    resources-qml.qrc \
    resources-images.qrc

PKGCONFIG += lipstick-qt5

OTHER_FILES += qml/*.qml

config.files = lipstick.conf
config.path = /usr/share/lipstick
INSTALLS += config

