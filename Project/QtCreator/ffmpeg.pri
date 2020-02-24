macx:contains(DEFINES, USE_BREW) {
    message("use ffmpeg from brew")

    PKGCONFIG += libavcodec libavfilter libavformat libpostproc
    PKGCONFIG += libswresample libswscale libavcodec libavutil

    CONFIG += link_pkgconfig

} else {
    FFMPEG = $$(FFMPEG)
    isEmpty(FFMPEG) {
        FFMPEG=$$absolute_path(../../../ffmpeg)
        message('FFMPEG: ' $$FFMPEG)
    }

    exists($$FFMPEG/include) {
        FFMPEG_INCLUDES=$$absolute_path($$FFMPEG/include)
    } else {
        FFMPEG_INCLUDES=$$FFMPEG
    }

    win32:exists($$FFMPEG/bin) {
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/bin)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/bin)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/bin)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/bin)

        FFMPEG_LIBS += \
                     -L$$absolute_path($$FFMPEG/bin) -lavfilter -lavformat -lavcodec -lpostproc -lswresample -lswscale -lavutil
    } else:exists($$FFMPEG/lib) {
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/lib)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/lib)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/lib)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/lib)

        FFMPEG_LIBS += \
                     -L$$absolute_path($$FFMPEG/lib) -lavfilter -lavformat -lavcodec -lpostproc -lswresample -lswscale -lavutil
    } else {
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/libavcodec)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/libavfilter)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/libavformat)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/libpostproc)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/libswresample)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/libswscale)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/libavutil)

        FFMPEG_LIBS += \
                     -L$$FFMPEG_AVCODEC -lavcodec \
                     -L$$FFMPEG_AVFILTER -lavfilter \
                     -L$$FFMPEG_POSTPROC -lpostproc \
                     -L$$FFMPEG_SWRESAMPLE -lswresample \
                     -L$$FFMPEG_SWSCALE -lswscale \
                     -L$$FFMPEG_AVUTIL -lavutil

    }

    unix:FFMPEG_LIBS += -L$$absolute_path($$FFMPEG/../freetype/usr/lib) -lfreetype
    win32 {
        contains(QT_ARCH, x86_64):FFMPEG_LIBS += -L$$absolute_path($$FFMPEG/../freetype/objs/x64/Release\ Static) -lfreetype
        else:FFMPEG_LIBS += -L$$absolute_path($$FFMPEG/../freetype/objs/Win32/Release\ Static) -lfreetype
    }

    INCLUDEPATH += $$FFMPEG_INCLUDES
    LIBS += $$FFMPEG_LIBS

    message('ffmpeg.pri INCLUDEPATH: ' $$INCLUDEPATH)
    message('ffmpeg.pri LIBS: ' $$LIBS)
}
