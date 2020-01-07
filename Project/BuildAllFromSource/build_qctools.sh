rm -fr qctools/Project/QtCreator/build
mkdir qctools/Project/QtCreator/build
pushd qctools/Project/QtCreator/build >/dev/null 2>&1
$BINQMAKE ..
make
popd >/dev/null 2>&1

echo QCTools binary is in qctools/Project/QtCreator/build/qctools-gui
