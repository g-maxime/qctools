message('entering ffmpeg.pri')

USE_BREW = $$(USE_BREW)

macx:!isEmpty(USE_BREW):equals(USE_BREW, true) {
    message("use qwt from brew")
    message("use ffmpeg from brew")

    PKGCONFIG += libavdevice libavcodec libavfilter libavformat libpostproc
    PKGCONFIG += libswresample libswscale libavcodec libavutil

    CONFIG += link_pkgconfig

} else {
    FFMPEG = $$(FFMPEG)
    isEmpty(FFMPEG) {
        FFMPEG=$$absolute_path(../../../ffmpeg)
        message('FFMPEG: ' $$FFMPEG)
    } else {
        message('specified FFMPEG: ' $$FFMPEG)
    }

    exists($$FFMPEG/include) {
        FFMPEG_INCLUDES=$$absolute_path($$FFMPEG/include)
    } else {
        FFMPEG_INCLUDES=$$FFMPEG
    }

    win32:!contains(STATIC, yes|1):exists($$FFMPEG/bin) {
        FFMPEG_AVDEVICE=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/bin)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/bin)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/bin)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/bin)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/bin)

        FFMPEG_LIBS += \
                    -L$$absolute_path($$FFMPEG/bin) -lavdevice -lavcodec -lavfilter -lavformat -lpostproc -lswresample -lswscale -lavutil
    } else:exists($$FFMPEG/lib) {
        FFMPEG_AVDEVICE=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/lib)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/lib)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/lib)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/lib)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/lib)

        FFMPEG_LIBS += \
                     -L$$absolute_path($$FFMPEG/lib) -lavdevice -lavfilter -lavformat -lavcodec -lpostproc -lswresample -lswscale -lavutil
    } else {
        FFMPEG_AVDEVICE=$$absolute_path($$FFMPEG/libavdevice)
        FFMPEG_AVCODEC=$$absolute_path($$FFMPEG/libavcodec)
        FFMPEG_AVFILTER=$$absolute_path($$FFMPEG/libavfilter)
        FFMPEG_AVFORMAT=$$absolute_path($$FFMPEG/libavformat)
        FFMPEG_POSTPROC=$$absolute_path($$FFMPEG/libpostproc)
        FFMPEG_SWRESAMPLE=$$absolute_path($$FFMPEG/libswresample)
        FFMPEG_SWSCALE=$$absolute_path($$FFMPEG/libswscale)
        FFMPEG_AVUTIL=$$absolute_path($$FFMPEG/libavutil)

        FFMPEG_LIBS += \
                     -L$$FFMPEG_AVDEVICE -lavdevice \
                     -L$$FFMPEG_AVFILTER -lavfilter \
                     -L$$FFMPEG_AVFORMAT -lavformat \
                     -L$$FFMPEG_AVCODEC -lavcodec \
                     -L$$FFMPEG_POSTPROC -lpostproc \
                     -L$$FFMPEG_SWRESAMPLE -lswresample \
                     -L$$FFMPEG_SWSCALE -lswscale \
                     -L$$FFMPEG_AVUTIL -lavutil
    }

    unix:FFMPEG_LIBS += -L$$absolute_path($$FFMPEG/../harfbuzz/usr/lib) -lharfbuzz
    unix:FFMPEG_LIBS += -L$$absolute_path($$FFMPEG/../freetype/usr/lib) -lfreetype
    unix:!mac:FFMPEG_LIBS += -lxcb -lxcb-shm -lxcb-xfixes -lxcb-render -lxcb-shape
    win32:contains(STATIC, yes|1) {
        contains(QT_ARCH, x86_64):FFMPEG_LIBS += -L$$absolute_path("$$FFMPEG/../freetype/objs/x64/ReleaseStatic") -lfreetype
        else:FFMPEG_LIBS += -L$$absolute_path("$$FFMPEG/../freetype/objs/Win32/ReleaseStatic") -lfreetype
    }

    INCLUDEPATH += $$FFMPEG_INCLUDES
    LIBS += $$FFMPEG_LIBS

    message('ffmpeg.pri INCLUDEPATH: ' $$INCLUDEPATH)
    message('ffmpeg.pri LIBS: ' $$LIBS)
}

message('leaving ffmpeg.pri')
