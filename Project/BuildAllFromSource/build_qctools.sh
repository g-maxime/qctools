rm -fr qctools/Project/QtCreator/build
mkdir qctools/Project/QtCreator/build
pushd qctools/Project/QtCreator/build >/dev/null 2>&1
$BINQMAKE .. DEFINES+=QT_AVPLAYER_MULTIMEDIA QMAKE_APPLE_DEVICE_ARCHS=x86_64
sed -i'' 's/-framework QtAVPlayer//g' qctools-gui/Makefile.*
make
popd >/dev/null 2>&1

echo QCTools binary is in qctools/Project/QtCreator/build/qctools-gui
