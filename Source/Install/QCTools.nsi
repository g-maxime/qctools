#NSIS: encoding=UTF-8
; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Some defines
!define PRODUCT_NAME "QCTools"
!define PRODUCT_PUBLISHER "MediaArea.net"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_VERSION4 "${PRODUCT_VERSION}.0.0"
!define PRODUCT_WEB_SITE "http://www.bavc.org/qctools"
!define COMPANY_REGISTRY "Software\MediaArea.net"
!define PRODUCT_REGISTRY "Software\MediaArea.net\QCTools"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\QCTools.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Compression
SetCompressor /FINAL /SOLID lzma

; Conditional
!include LogicLib.nsh

; x64 stuff
!include "x64.nsh"

; File size
!include FileFunc.nsh
!include WinVer.nsh

; Modern UI
!include "MUI2.nsh"
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\Source\Resource\Logo.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
; !define MUI_FINISHPAGE_RUN "$INSTDIR\QCTools.exe" //Removing it because it is run in admin privileges
!insertmacro MUI_PAGE_FINISH
; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; Info
VIProductVersion "${PRODUCT_VERSION4}"
VIAddVersionKey "CompanyName"      "${PRODUCT_PUBLISHER}"
VIAddVersionKey "ProductName"      "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion"   "${PRODUCT_VERSION4}"
VIAddVersionKey "FileDescription"  "QCTools"
VIAddVersionKey "FileVersion"      "${PRODUCT_VERSION4}"
VIAddVersionKey "LegalCopyright"   "${PRODUCT_PUBLISHER}"
VIAddVersionKey "OriginalFilename" "${PRODUCT_NAME}_${PRODUCT_VERSION}_Windows.exe"
BrandingText " "

; Modern UI end

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\..\${PRODUCT_NAME}_${PRODUCT_VERSION}_Windows.exe"
InstallDir "$PROGRAMFILES64\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails nevershow
ShowUnInstDetails nevershow

Function .onInit
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
FunctionEnd

Section "SectionPrincipale" SEC01
  SetOverwrite on
  SetOutPath "$SMPROGRAMS"
  CreateShortCut "$SMPROGRAMS\QCTools.lnk" "$INSTDIR\QCTools.exe" "" "$INSTDIR\QCTools.exe" 0 "" "" "QCTools"
  SetOutPath "$INSTDIR"
  !ifndef STATIC
    File "..\..\Project\QtCreator\build\qctools-gui\release\QCTools.exe"
    File "..\..\Project\QtCreator\build\qctools-cli\release\qcli.exe"
  !else
    File "..\..\Project\QtCreator\build\qctools-gui\StaticRelease\QCTools.exe"
    File "..\..\Project\QtCreator\build\qctools-cli\StaticRelease\qcli.exe"
  !endif
  File "..\..\History.txt"
  File "..\..\License.html"
  !ifndef STATIC
    File "..\..\..\freetype\objs\Win32\Release\freetype.dll"
    File "..\..\..\ffmpeg\libavcodec\avcodec-*.dll"
    File "..\..\..\ffmpeg\libavfilter\avfilter-*.dll"
    File "..\..\..\ffmpeg\libavformat\avformat-*.dll"
    File "..\..\..\ffmpeg\libavutil\avutil-*.dll"
    File "..\..\..\ffmpeg\libpostproc\postproc-*.dll"
    File "..\..\..\ffmpeg\libswresample\swresample-*.dll"
    File "..\..\..\ffmpeg\libswscale\swscale-*.dll"
    File "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Redist\MSVC\14.11.25325\x86\Microsoft.VC141.CRT\concrt140.dll"
    File "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Redist\MSVC\14.11.25325\x86\Microsoft.VC141.CRT\msvcp140.dll"
    File "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Redist\MSVC\14.11.25325\x86\Microsoft.VC141.CRT\vccorlib140.dll"
    File "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Redist\MSVC\14.11.25325\x86\Microsoft.VC141.CRT\vcruntime140.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\QtAV1.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\QtAVWidgets1.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Core.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Gui.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Network.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5OpenGL.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Qml.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Svg.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\Qt5Widgets.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\d3dcompiler_47.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\libEGL.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\libGLESV2.dll"
    SetOutPath "$INSTDIR\imageformats"
    File "..\..\Project\QtCreator\build\qctools-gui\release\imageformats\qjpeg.dll"
    File "..\..\Project\QtCreator\build\qctools-gui\release\imageformats\qsvg.dll"
    SetOutPath "$INSTDIR\platforms"
    File "..\..\Project\QtCreator\build\qctools-gui\release\platforms\qwindows.dll"
  !endif
  # Create files
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\QCTools.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName"     "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher"       "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon"     "$INSTDIR\QCTools.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout"    "${PRODUCT_WEB_SITE}"

  ${If} ${AtLeastWin7}
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0 ; Convert the decimal KB value in $0 to DWORD, put it right back into $0
    WriteRegDWORD ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0" ; Create/Write the reg key with the dword value
  ${EndIf}
SectionEnd


Section Uninstall
  SetRegView 64

  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\QCTools.exe"
  Delete "$INSTDIR\qcli.exe"
  Delete "$INSTDIR\History.txt"
  Delete "$INSTDIR\License.html"
  !ifndef STATIC
    Delete "$INSTDIR\freetype.dll"
    Delete "$INSTDIR\avcodec-*.dll"
    Delete "$INSTDIR\avfilter-*.dll"
    Delete "$INSTDIR\avformat-*.dll"
    Delete "$INSTDIR\avutil-*.dll"
    Delete "$INSTDIR\postproc-*.dll"
    Delete "$INSTDIR\swresample-*.dll"
    Delete "$INSTDIR\swscale-*.dll"
    Delete "$INSTDIR\concrt140.dll"
    Delete "$INSTDIR\msvcp140.dll"
    Delete "$INSTDIR\vccorlib140.dll"
    Delete "$INSTDIR\vcruntime140.dll"
    Delete "$INSTDIR\QtAV1.dll"
    Delete "$INSTDIR\QtAVWidgets1.dll"
    Delete "$INSTDIR\Qt5Core.dll"
    Delete "$INSTDIR\Qt5Gui.dll"
    Delete "$INSTDIR\Qt5Network.dll"
    Delete "$INSTDIR\Qt5OpenGL.dll"
    Delete "$INSTDIR\Qt5Qml.dll"
    Delete "$INSTDIR\Qt5Svg.dll"
    Delete "$INSTDIR\Qt5Widgets.dll"
    Delete "$INSTDIR\d3dcompiler_47.dll"
    Delete "$INSTDIR\libEGL.dll"
    Delete "$INSTDIR\libGLESV2.dll"
    Delete "$INSTDIR\imageformats\qjpeg.dll"
    Delete "$INSTDIR\imageformats\qsvg.dll"
    Delete "$INSTDIR\platforms\qwindows.dll"
    Delete "$INSTDIR\iconengines\qsvgicon.dll"
    RMDir "$INSTDIR\iconengines"
    RMDir "$INSTDIR\imageformats"
    RMDir "$INSTDIR\platforms"
  !endif
  RMDir  "$INSTDIR"
  Delete "$SMPROGRAMS\QCTools.lnk"

  SetRegView 64
  DeleteRegKey HKLM "${PRODUCT_REGISTRY}"
  DeleteRegKey /ifempty HKLM "${COMPANY_REGISTRY}"
  DeleteRegKey HKCU "${PRODUCT_REGISTRY}"
  DeleteRegKey /ifempty HKCU "${COMPANY_REGISTRY}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
