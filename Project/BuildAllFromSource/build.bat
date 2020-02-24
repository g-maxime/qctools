@echo off

rem ***********************************************************************************************
rem * build.bat - Batch script for building Windows version of QCTools                            *
rem *                                                                                             *
rem *Script requirements:                                                                         *
rem * - Microsoft Visual Studio 2017 at the default place                                         *
rem * - qctools_AllInclusive source tree                                                          *
rem * - Qt bin directory corresponding to the requested build type (static or shared, x86 or x64) *
rem *   in the PATH                                                                               *
rem * - Cygwin directory with bash, sed, make and diffutils in the PATH                           *
rem * - yasm.exe in the PATH if not provided by Cygwin                                            *
rem * Options:                                                                                    *
rem * - /static           - build statically linked binary                                        *
rem * - /target x86|x64   - target arch (default x86)                                             *
rem * - /nogui            - build only qcli                                                       *
rem ***********************************************************************************************

rem *** Init ***
set ARCH=x86
set STATIC=
set NOGUI=

set OLD_CD="%CD%"
set OLD_PATH=%PATH%
set BUILD_DIR="%~dp0..\..\.."

set CHERE_INVOKING=1

rem *** Initialize bash user files (needed to make CHERE_INVOKING work) ***
bash --login -c "exit"

rem *** Parse command line ***
:cmdline
if not "%1"=="" (
    if /I "%1"=="/static" set STATIC=1
    if /I "%1"=="/nogui" set NOGUI=1
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

rem *** Get VC tools path ***
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %ARCH%

if "%ARCH%"=="x86" set PLATFORM=Win32
if "%ARCH%"=="x64" set PLATFORM=x64


rem *** Build freetype ***
cd "%BUILD_DIR%\freetype\builds\windows\vc2010"
sed -i "s/>v100</>v141</g" freetype.vcxproj
if defined STATIC (
    MSBuild /t:Clean;Build /p:Configuration=Release^ Static;Platform=%PLATFORM%
) else (
    MSBuild /t:Clean;Build /p:Configuration=Release;Platform=%PLATFORM%
)

rem *** Build ffmpeg ***
set FFMPEG_CMDLINE=--prefix^=. --disable-avdevice --disable-programs --enable-gpl --enable-version3 --toolchain^=msvc
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --disable-securetransport --disable-videotoolbox  --disable-ffplay --disable-ffprobe
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --disable-doc --disable-debug
set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-libfreetype --extra-cflags^=-I../freetype/include

if not defined STATIC (
    if "%ARCH%"=="x64" (
        set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --extra-libs^=../freetype/objs/x64/Release/freetype.lib
    ) else (
        set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --extra-libs^=../freetype/objs/Win32/Release/freetype.lib
    )
)

if defined STATIC (
    set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-static --disable-shared
) else (
    set FFMPEG_CMDLINE=%FFMPEG_CMDLINE% --enable-shared --disable-static
)

cd "%BUILD_DIR%\ffmpeg"
if exist Makefile bash --login -c "make clean uninstall"
bash --login -c "./configure %FFMPEG_CMDLINE%"
bash --login -c "make install"

if defined STATIC forfiles /S /M *.a /C "cmd /c rename @file ///*.lib"

rem *** Build qwt ***
cd "%BUILD_DIR%\qwt"
if not defined NOGUI (
    rem TODO: Make dynamically linked version of QWT work
    if exist Makefile nmake distclean
    qmake -recursive
    nmake Release
)

rem *** Build QCTools ***
rmdir /S /Q "%BUILD_DIR%\qctools\Project\QtCreator\build"
mkdir "%BUILD_DIR%\qctools\Project\QtCreator\build"
cd "%BUILD_DIR%\qctools\Project\QtCreator\build"

qmake QMAKE_CXXFLAGS+=/Zi QMAKE_LFLAGS+=/INCREMENTAL:NO QMAKE_LFLAGS+=/Debug ..
if not defined NOGUI (
    nmake
) else (
    nmake sub-qctools-cli
)

if not defined STATIC (
    windeployqt qctools-gui/release/QtAV1.dll
    windeployqt qctools-gui/release/QtAVWidgets1.dll
    windeployqt qctools-gui/release/QCTools.exe

    windeployqt qctools-cli/release/qcli.exe
)

rem *** Cleaning ***
:clean
set PATH=%OLD_PATH%
cd %OLD_CD%
