win32 {
    ZLIB_INCLUDE_PATH = $$[QT_INSTALL_HEADERS]/QtZlib
    message("qctools-lib: ZLIB_INCLUDE_PATH = " $$ZLIB_INCLUDE_PATH)
    INCLUDEPATH += $$ZLIB_INCLUDE_PATH
    contains(STATIC, yes|1):exists($$FFMPEG/lib/zlib.lib) {
        LIBS += -L$$absolute_path($$FFMPEG/lib) -lzlib
    }
}

unix {
    LIBS += -lz
}
