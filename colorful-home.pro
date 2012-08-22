
# This file is part of colorful-home, a user experience for touchscreens
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License version 2.1 as published by the Free Software Foundation
# and appearing in the file LICENSE.LGPL included in the packaging
# of this file.
#
# This code is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# Copyright (c) 2012, Timur Kristóf <venemo@fedoraproject.org>

TEMPLATE = subdirs
CONFIG += ordered
SUBDIRS += src

QMAKE_CLEAN += \
    Makefile \
    */Makefile \
    build-stamp \
    configure-stamp

QMAKE_DISTCLEAN += \
    Makefile \
    */Makefile \
    build-stamp \
    configure-stamp

OTHER_FILES += \
    README.md
