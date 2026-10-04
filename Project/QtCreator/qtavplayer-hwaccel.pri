# Enables QtAVPlayer's existing VAAPI hw-decode backend on Linux.
#
# QtAVPlayer.pri links -lva/-lva-drm unconditionally once the DEFINES
# below are set, with no internal existence guard, so this is guarded
# here via pkg-config to avoid breaking Linux builds/CI that lack the
# libva dev packages.
#
# Must be included before QtAVPlayer.pri, since qmake evaluates
# contains(DEFINES, ...) checks in file order.

unix:!macx {
    CONFIG += link_pkgconfig
    packagesExist(libva libva-drm) {
        DEFINES += QT_AVPLAYER_VA_DRM
        message("HW acceleration: VAAPI/DRM backend enabled")
    } else {
        message("HW acceleration: libva-drm not found via pkg-config, VAAPI/DRM backend disabled")
    }
}

# Enables QtAVPlayer's Vulkan hw-decode backend.
#
# qavhwdevice_vulkan.cpp is already compiled unconditionally by
# QtAVPlayer.pri; this define just activates it in qavdemuxer.cpp's
# device list. It does its own device creation and CPU readback via
# plain FFmpeg calls (av_hwdevice_ctx_create / av_hwframe_transfer_data),
# so no extra Vulkan headers/libs need to be linked here on QTAVPlayer's
# side - that's entirely up to how FFmpeg itself was built
# (--enable-vulkan). This is what lets FFmpeg's Vulkan compute-shader
# decoders (FFV1, DPX, ProRes - none of which have a fixed-function
# hwaccel ASIC) get used once FFmpeg is built with that support.
#
# On Windows/macOS this is unconditional (BuildAllFromSource's build.sh/
# build.ps1 now build FFmpeg with --enable-vulkan there). On Linux it's
# guarded by pkg-config, same spirit as the VAAPI/DRM block above, since
# the Debian/spec/PKGBUILD FFmpeg builds don't enable --enable-vulkan yet.
win32|macx {
    DEFINES += QT_AVPLAYER_VULKAN
    message("HW acceleration: Vulkan backend enabled")
}

unix:!macx {
    CONFIG += link_pkgconfig
    packagesExist(vulkan) {
        DEFINES += QT_AVPLAYER_VULKAN
        message("HW acceleration: Vulkan backend enabled")
    } else {
        message("HW acceleration: vulkan not found via pkg-config, Vulkan backend disabled")
    }
}
