isEmpty(QTAVPLAYER) {
    QTAVPLAYER = $$(QTAVPLAYER)
}
message('QTAVPLAYER: ' $$QTAVPLAYER)

isEmpty(FFMPEG) {
    FFMPEG = $$(FFMPEG)
}
message('FFMPEG: ' $$FFMPEG)
!isEmpty(FFMPEG) {

    oldConf = $$cat($$QTAVPLAYER/.qmake.conf.backup, lines)
    isEmpty(oldConf) {
        oldConf = $$cat($$QTAVPLAYER/.qmake.conf, lines)
        message('writting backup of original .qmake.conf')
        write_file($$QTAVPLAYER/.qmake.conf.backup, oldConf)
    } else {
        message('reading backup of original .qmake.conf.backup')
    }

    message('oldConf: ' $$oldConf)
    write_file($$QTAVPLAYER/.qmake.conf, oldConf)

    exists($$FFMPEG/include) {
        FFMPEG_INCLUDES=$$absolute_path($$FFMPEG/include)
    } else {
        FFMPEG_INCLUDES=$$FFMPEG
    }

    ffmpegIncludes = "INCLUDEPATH+=$$FFMPEG_INCLUDES"
    ffmpegLibs = "LIBS+=$$FFMPEG_LIBS"
    ffmpegExtraIncludes = "EXTRA_INCLUDEPATH+=$$FFMPEG_INCLUDES"
    ffmpegExtraLibs = "EXTRA_LIBDIR+=$$FFMPEG_EXTRA_LIBS"

    write_file($$QTAVPLAYER/.qmake.conf, ffmpegIncludes, append)
    write_file($$QTAVPLAYER/.qmake.conf, ffmpegLibs, append)

    write_file($$QTAVPLAYER/.qmake.conf, ffmpegExtraIncludes, append)
    write_file($$QTAVPLAYER/.qmake.conf, ffmpegExtraLibs, append)
}
