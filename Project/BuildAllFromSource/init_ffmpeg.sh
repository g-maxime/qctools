#! /bin/bash

echo "PWD: " + $PWD

_install_yasm(){
    wget -q http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar -zxf yasm-1.3.0.tar.gz
    mv yasm-1.3.0 yasm
}

if [ ! -d ffmpeg ] ; then
    git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg
fi

if [ ! -d freetype ] ; then
    curl -LO https://download.savannah.gnu.org/releases/freetype/freetype-2.10.0.tar.bz2
    tar -xf freetype-2.10.0.tar.bz2
    mv freetype-2.10.0 freetype
fi

cd freetype
chmod u+x configure
if sw_vers >/dev/null 2>&1 ; then
./configure --prefix="$(pwd)/usr" --without-zlib --without-bzip2 --without-png --without-harfbuzz --enable-static --disable-shared CFLAGS=-mmacosx-version-min=10.10 LDFLAGS=-mmacosx-version-min=10.10
else
./configure --prefix="$(pwd)/usr" --without-zlib --without-bzip2 --without-png --without-harfbuzz --enable-static --disable-shared
fi
make
make install
cd ..

cd ffmpeg
FFMPEG_CONFIGURE_OPTS=(--enable-gpl --enable-version3 --disable-autodetect --disable-programs --disable-securetransport --disable-videotoolbox --enable-static --disable-shared --disable-doc --disable-debug --disable-lzma --disable-iconv --enable-pic --prefix="$(pwd)" --enable-libfreetype --extra-cflags=-I../freetype/include)
if sw_vers >/dev/null 2>&1 ; then
    FFMPEG_CONFIGURE_OPTS+=(--disable-autodetect --extra-cflags="-mmacosx-version-min=10.10" --extra-ldflags="-mmacosx-version-min=10.10")
fi

chmod u+x configure
chmod u+x version.sh
if yasm --version >/dev/null 2>&1 ; then
    echo "FFMPEG_CONFIGURE_OPTS = ${FFMPEG_CONFIGURE_OPTS[@]}"
    ./configure "${FFMPEG_CONFIGURE_OPTS[@]}"
    if [ "$?" -ne 0 ] ; then #on some distro, yasm version is too old
        cd "$INSTALL_DIR"
        if [ ! -d yasm ] ; then
            _install_yasm
        fi
        cd yasm/
        ./configure --prefix="$(pwd)/usr"
        make
        make install
        cd "${INSTALL_DIR}/ffmpeg"
        FFMPEG_CONFIGURE_OPTS+=(--x86asmexe=../yasm/usr/bin/yasm)
        echo "FFMPEG_CONFIGURE_OPTS = ${FFMPEG_CONFIGURE_OPTS[@]}"
        ./configure "${FFMPEG_CONFIGURE_OPTS[@]}"
    fi
else
    cd "$INSTALL_DIR"
    if [ ! -d yasm ] ; then
        _install_yasm
    fi
    cd yasm/
    ./configure --prefix=`pwd`/usr
    make
    make install
    cd "${INSTALL_DIR}/ffmpeg"
    FFMPEG_CONFIGURE_OPTS+=(--x86asmexe=../yasm/usr/bin/yasm)
    echo "FFMPEG_CONFIGURE_OPTS = ${FFMPEG_CONFIGURE_OPTS[@]}"
    ./configure "${FFMPEG_CONFIGURE_OPTS[@]}"
fi
make
make install
cd "$INSTALL_DIR"
