@echo on

rem ***********************************************************************************************
rem * build.bat - Batch script for building Windows version of QCTools                            *
rem *                                                                                             *
rem *Script requirements:                                                                         *
rem * - Microsoft Visual Studio 2019 at the default place                                         *
rem * - qctools_AllInclusive source tree                                                          *
rem * - Qt bin directory corresponding to the requested build type (static or shared, x86 or x64) *
rem *   in the PATH                                                                               *
rem * - Cygwin directory with bash, sed, make and diffutils in the PATH                           *
rem * - yasm.exe in the PATH if not provided by Cygwin                                            *
rem * Options:                                                                                    *
rem * - /static           - build statically linked binary                                        *
rem * - /target x86|x64   - target arch (default x86)                                             *
rem * - /nogui            - build only qcli                                                       *
rem * - /prebuild_ffmpeg  - assume that ffmpeg is already builds                                  *
rem ***********************************************************************************************

rem *** Init ***
set ARCH=x86
set STATIC=
set NOGUI=
set NO_BUILD_FFMPEG=
set QMAKEOPTS=

set OLD_CD=%CD%
set OLD_PATH=%PATH%
set BUILD_DIR=%~dp0..\..\..

set CHERE_INVOKING=1

rem *** Initialize bash user files (needed to make CHERE_INVOKING work) ***
bash --login -c "exit"

rem *** Parse command line ***
:cmdline
if not "%1"=="" (
    if /I "%1"=="/static" set STATIC=1
    if /I "%1"=="/nogui" set NOGUI=1
    if /I "%1"=="/prebuild_ffmpeg" set NO_BUILD_FFMPEG=1
    if /I "%1"=="/target" (
        set ARCH=%2
        shift
    )
    shift
    goto:cmdline
)

if not "%ARCH%"=="x86" if not "%ARCH%"=="x64" (
    echo ERROR: Unknown value for arch %ARCH%
    goto:clean
)

if defined STATIC (
    set QMAKEOPTS=STATIC^=1
)

rem *** Get VC tools path ***
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" %ARCH%

if "%ARCH%"=="x86" set PLATFORM=Win32
if "%ARCH%"=="x64" set PLATFORM=x64

set FFMPEG_CMDLINE=--prefix^=. --disable-programs --enable-gpl --enable-version3 --toolchain^=msvc
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --disable-securetransport --disable-videotoolbox
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --disable-doc --disable-debug
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-libfreetype --extra-cflags^=-I../freetype/usr/include/freetype2
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-libharfbuzz --extra-cflags^=-I../harfbuzz/usr/include/harfbuzz
if defined STATIC (
    set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-static --disable-shared
) else (
    set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-shared --disable-static
)

if not defined NO_BUILD_FFMPEG (
    rem *** Build freetype ***
    cd "%BUILD_DIR%\freetype"
    mkdir build
    pushd build
        meson setup --prefix %BUILD_DIR%\freetype\usr --default-library=static -Db_vscrt=md -Dbrotli=disabled -Dbzip2=disabled -Dharfbuzz=disabled -Dpng=disabled -Dzlib=internal ..
        ninja install
    popd

    rem *** Build harfbuzz ***
    cd "%BUILD_DIR%\harfbuzz"
    mkdir build
    pushd build
        set PKG_CONFIG_PATH=%BUILD_DIR%\freetype\usr\lib\pkgconfig
        meson setup --prefix %BUILD_DIR%\harfbuzz\usr --default-library=static -Db_vscrt=md -Dglib=disabled -Dgobject=disabled -Dcairo=disabled -Dchafa=disabled -Dicu=disabled -Dgraphite=disabled -Dgraphite2=disabled -Dgdi=disabled -Ddirectwrite=disabled -Dcoretext=disabled -Dwasm=disabled -Dtests=disabled -Dintrospection=disabled -Ddocs=disabled -Ddoc_tests=false -Dutilities=disabled ..
        ninja install
    popd

    rem *** Build ffmpeg ***
    cd "%BUILD_DIR%\ffmpeg"
    rename ..\harfbuzz\usr\lib\libharfbuzz.a harfbuzz.lib
    rename ..\freetype\usr\lib\libfreetype.a freetype.lib
    if exist Makefile bash --login -c "make clean uninstall"
    if exist lib bash --login -c "rm -f lib/*.lib"
    bash --login -c "sed -i 's/^enabled libfreetype.*//g' configure"
    bash --login -c "sed -i 's/^enabled libharfbuzz.*//g' configure"
    bash --login -c "./configure %FFMPEG_CMDLINE% --extra-libs='../freetype/usr/lib/freetype.lib ../harfbuzz/usr/lib/harfbuzz.lib'"
    bash --login -c "make install"

    if defined STATIC forfiles /S /M *.a /C "cmd /c rename @file ///*.lib"
)

rem *** Build qwt ***
cd "%BUILD_DIR%\qwt"
if not defined NOGUI (
    rem TODO: Make dynamically linked version of QWT work
    if exist Makefile nmake distclean
    set QWT_STATIC=1
    set QWT_NO_SVG=1
    set QWT_NO_OPENGL=1
    set QWT_NO_DESIGNER=1
    qmake -recursive
    nmake Release
)

rem *** Build QCTools ***
rmdir /S /Q "%BUILD_DIR%\qctools\Project\QtCreator\build"
mkdir "%BUILD_DIR%\qctools\Project\QtCreator\build"
cd "%BUILD_DIR%\qctools\Project\QtCreator\build"

qmake %QMAKEOPTS% DEFINES+=QT_AVPLAYER_MULTIMEDIA QMAKE_CXXFLAGS+=/Zi QMAKE_LFLAGS+=/INCREMENTAL:NO QMAKE_LFLAGS+=/Debug ..
if not defined NOGUI (
    nmake
) else (
    nmake sub-qctools-cli
)

if not defined STATIC (
    windeployqt qctools-gui/release/QCTools.exe
    windeployqt qctools-cli/release/qcli.exe
)

rem *** Cleaning ***
:clean
set PATH=%OLD_PATH%
cd %OLD_CD%
