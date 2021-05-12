#!/usr/bin/env bash

# set -x

function usage() {
    echo "eg: ./build.sh ubuntu/himix200"
    exit
}

if [[ $# != 1 ]]; then
    usage
fi

data_disk_path=/opt/data
qt_src_path=${data_disk_path}/opt/qt/qt-everywhere-src-5.12.10/qtbase
# qt_src_path=${data_disk_path}/opt/qt/qt-everywhere-src-5.12.10

if [[ $1 = "ubuntu" ]]; then
    install_prefix=${data_disk_path}/usr/local
    platform_args=""
elif [[ $1 = "himix200" ]]; then
    himix200_install_path=${data_disk_path}/install/hisi-linux/arm-himix200-linux
    install_prefix=$himix200_install_path
    platform_args="                             \
        -no-opengl                              \
        -I$himix200_install_path/include        \
        -L$himix200_install_path/lib            \
        -xplatform linux-arm-himix200-g++       \
        "
else
    usage
fi

base_configs="                  \
    -prefix $install_prefix     \
    -opensource                 \
    -confirm-license            \
    -release                    \
    -shared                     \
    -optimize-size              \
    -ccache                     \
    $platform_args              \
    "

component_selection="           \
    -nomake tests               \
    -nomake examples            \
    -no-dbus                    \
    "

core_options="                  \
    -no-iconv                   \
    "

mkdir -p $1
cd $1
rm -rf config.cache config.summary

${qt_src_path}/configure        \
    $base_configs               \
    $component_selection        \
    $core_options

cp config.cache ../
cp config.summary ../

