#!/bin/sh

top_path=/mnt/meian

# project
target_path=${top_path}/meian

# qt
qt_path=${top_path}/qt-5.12.10

# 3rd_lib
lib_3rd_path=${top_path}/3rd-lib

# res
fonts_path=${top_path}/fonts

# --------------------------------------

export LD_LIBRARY_PATH=${qt_path}/lib:${lib_3rd_path}/lib

# qt env
export QT_QPA_PLATFORM_PLUGIN_PATH=${qt_path}/plugins/platforms
export QT_QPA_PLATFORM="linuxFB:fb=/dev/fb0:size=800x1280:mmSize=800x1280:offset=0x0:rotation=90"
export QT_QPA_FONTDIR=${fonts_path}


cd ${target_path}/bin && ./main && cd -

