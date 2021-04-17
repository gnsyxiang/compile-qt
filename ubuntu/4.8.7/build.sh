#!/usr/bin/env bash

function usage() {
    echo "eg: ./build.sh ubuntu/himix200"
    exit
}

if [[ $# != 1 ]]; then
    usage
fi

data_disk_path=$HOME/data
qt_src_path=${data_disk_path}/opt/qt/qt-everywhere-opensource-src-4.8.7

if [[ $1 = "ubuntu" ]]; then
    install_prefix=${data_disk_path}/usr/local
    platform_args=
elif [[ $1 = "himix200" ]]; then
    himix200_install_path=${data_disk_path}/install/hisi-linux/arm-himix200-linux
    install_prefix=$himix200_install_path
    platform_args=" \
        -I$himix200_install_path/include \
        -L$himix200_install_path/lib \
        -linuxfb \
        -qpa linuxfb \
        -xplatform qws/linux-arm-himix200-g++"
else
    usage
fi

system_third_lib=""

qt_third_lib=" \
    -qt-zlib \
    -qt-libjpeg \
    -qt-libpng \
    -qt-freetype"

skip_modules=""

no_feature=""

select_feature=""

no_make_module="\
    -nomake tests \
    -nomake examples"

make_module="\
    -make libs \
    -make tools"

mkdir -p $1
cd $1
rm -rf config.cache

${qt_src_path}/configure \
    -prefix $install_prefix \
    -release \
    -opensource -confirm-license \
    \
    $make_module \
    $no_make_module \
    $no_feature \
    $select_feature \
    $skip_modules \
    $qt_third_lib \
    $system_third_lib \
    $platform_args

