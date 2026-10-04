# Enables QtAVPlayer's VAAPI hw-decode backend on Linux.
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
DEFINES += QT_AVPLAYER_VULKAN
message("HW acceleration: Vulkan backend enabled")
