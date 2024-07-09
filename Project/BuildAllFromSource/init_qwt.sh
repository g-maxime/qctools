#! /bin/bash

echo "PWD: " + $PWD

if [ ! -d qwt ] ; then
    wget wget -q https://github.com/ElderOrb/qwt/archive/master.zip
    unzip master.zip
    mv qwt-master qwt
    rm master.zip
fi
cd qwt
export QWT_STATIC=1 QWT_NO_SVG=1 QWT_NO_OPENGL=1 QWT_NO_DESIGNER=1
$BINQMAKE QMAKE_APPLE_DEVICE_ARCHS=x86_64
make
cd "$INSTALL_DIR"
