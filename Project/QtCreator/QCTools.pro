TEMPLATE = subdirs
message('entering QCTools.pro')
message('QCTools.pro INCLUDEPATH: ' $$INCLUDEPATH)

include(ffmpeg.pri)

contains(DEFINES, USE_BREW) {
    message('using ffmpeg from brew via PKGCONFIG')

    pkgConfig = "PKGCONFIG += libavdevice libavcodec libavfilter libavformat libpostproc libswresample libswscale libavcodec libavutil"
    linkPkgConfig = "CONFIG += link_pkgconfig"

    message('pkgConfig: ' $$pkgConfig)
    message('linkPkgConfig: ' $$linkPkgConfig)
}

unix: {
    linkStatic = "CONFIG += static staticlib"
    message('linkStatic: ' $$linkStatic)

    write_file($$QTAVPLAYER/.qmake.conf, linkStatic, append)
}

SUBDIRS = \
        qctools-lib \
        qctools-cli \
        qctools-gui

qctools-lib.subdir = qctools-lib
qctools-cli.subdir = qctools-cli
qctools-gui.subdir = qctools-gui

qctools-cli.depends = qctools-lib
qctools-gui.depends = qctools-lib

message('leaving QCTools.pro')
