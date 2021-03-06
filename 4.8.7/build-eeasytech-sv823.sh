#!/usr/bin/env bash

# set -x

default_install_path=/mnt/soft/qt/4.8.7
default_build_path=/mnt/data/build/qt/4.8.7/build-ubuntu

function usage()
{
    echo "eg: ./build.sh src-path [${default_install_path}] [${default_build_path}]"
    exit
}

if [ $# -lt 1 -o  $# -gt 3 ]; then
    usage
elif [ $# -eq 1 ]; then
    install_path=${default_install_path}
    build_path=${default_build_path}
elif [ $# -eq 2 ]; then
    install_path=$2
    build_path=${default_build_path}
elif [ $# -eq 3 ]; then
    install_path=$2
    build_path=$3
fi

mkdir -p ${install_path}

mkdir -p ${build_path}
cd ${build_path}
rm -rf config.cache

${1}/configure                      \
    -v                              \
    -prefix $install_path           \
    -release                        \
    -opensource -confirm-license    \
    \
    -make libs                      \
    -make tools                     \
    \
    -nomake tests                   \
    -nomake examples                \
    \
    -system-zlib                    \
    -system-libjpeg                 \
    -system-libpng                  \
    -system-freetype                \
    \
    -I${install_path}/include       \
    -I${install_path}/include/freetype2 \
    -L${install_path}/lib           \
    -embedded arm                   \
    -xplatform qws/linux-arm-eeasytech-sv823-g++

thread_jobs=`getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`

cd ${build_path}
make -j${thread_jobs} && make install


