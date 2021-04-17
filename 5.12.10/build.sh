#!/usr/bin/env bash

function usage() {
    echo "eg: ./build.sh ubuntu/himix200"
    exit
}

if [[ $# != 1 ]]; then
    usage
fi

data_disk_path=$HOME/data
qt_src_path=${data_disk_path}/opt/qt/qt-everywhere-src-5.12.10

if [[ $1 = "ubuntu" ]]; then
    install_prefix=${data_disk_path}/usr/local
    platform_args=""
elif [[ $1 = "himix200" ]]; then
    himix200_install_path=${data_disk_path}/install/hisi-linux/arm-himix200-linux
    install_prefix=$himix200_install_path
    platform_args="                             \
        -I$himix200_install_path/include        \
        -L$himix200_install_path/lib            \
        -embedded arm                           \
        -xplatform linux-arm-himix200-g++       \
        "
else
    usage
fi

system_third_lib="              \
    -system-zlib                \
    -system-libjpeg             \
    -system-libpng              \
    -system-freetype            \
    -system-pcre                \
    -system-harfbuzz            \
    "

qt_third_lib="                  \
    "

third_lib="                     \
    $system_third_lib           \
    $qt_third_lib               \
    "

no_make_module="                \
    -nomake tests               \
    -nomake examples            \
    "

make_module="                   \
    -make libs                  \
    -make tools                 \
    "

component_selection="           \
    $no_make_module             \
    $make_module                \
    "

base_configs="                  \
    -prefix $install_prefix     \
    -verbose                    \
    -opensource                 \
    -confirm-license            \
    -release                    \
    -shared                     \
    -ccache                     \
    $platform_args              \
    "

mkdir -p $1
cd $1
rm -rf config.cache config.summary

${qt_src_path}/configure        \
    $base_configs               \
    $third_lib                  \
    $component_selection

cp config.cache ../
cp config.summary ../

