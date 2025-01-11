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

if [ ! -d harfbuzz ] ; then
    curl -LO https://github.com/harfbuzz/harfbuzz/releases/download/8.2.2/harfbuzz-8.2.2.tar.xz
    tar -Jxf harfbuzz-8.2.2.tar.xz
    rm harfbuzz-8.2.2.tar.xz
    mv harfbuzz-8.2.2 harfbuzz
fi

export PKG_CONFIG_PATH=$PWD/output/lib/pkgconfig
if sw_vers >/dev/null 2>&1 ; then
export CFLAGS="-mmacosx-version-min=11.0"
export CXXFLAGS="-mmacosx-version-min=11.0"
export LDFLAGS="-mmacosx-version-min=11.0"
fi

cd freetype
mkdir build
cd build
meson setup --prefix $PWD/../../output --default-library=static -Dzlib=disabled -Dbzip2=disabled -Dpng=disabled -Dharfbuzz=disabled -Dbrotli=disabled ..
ninja install
cd ..
cd ..

cd harfbuzz
mkdir build
cd build
meson setup --prefix $PWD/../../output --default-library=static -Dglib=disabled -Dgobject=disabled -Dcairo=disabled -Dchafa=disabled -Dicu=disabled -Dgraphite=disabled -Dgraphite2=disabled -Dgdi=disabled -Ddirectwrite=disabled -Dcoretext=disabled -Dwasm=disabled -Dtests=disabled -Dintrospection=disabled -Ddocs=disabled -Ddoc_tests=false -Dutilities=disabled ..
ninja install
cd ..
cd ..

cd ffmpeg
FFMPEG_CONFIGURE_OPTS=(--enable-gpl --enable-version3 --disable-autodetect --disable-programs --disable-securetransport --disable-videotoolbox --enable-static --disable-shared --disable-doc --disable-debug --disable-lzma --disable-iconv --enable-pic --prefix="$PWD" --enable-libfreetype --enable-libharfbuzz)
if sw_vers >/dev/null 2>&1 ; then
    FFMPEG_CONFIGURE_OPTS+=(--extra-cflags="-mmacosx-version-min=11.0" --extra-ldflags="-mmacosx-version-min=11.0")
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
