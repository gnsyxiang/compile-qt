#!/usr/bin/env bash

# set -x

default_install_path=/mnt/soft/qt/5.12.12
default_build_path=/mnt/data/build/qt/5.12.12/build-ubuntu

function usage() {
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
rm -rf config.cache config.summary

${1}/configure                          \
    -prefix ${install_path}             \
    -release                            \
    -opensource -confirm-license        \
    -shared                             \
    -optimize-size                      \
    -ccache                             \
    \
    -nomake tests                       \
    -nomake examples                    \
    \
    -system-zlib                        \
    -system-libjpeg                     \
    -system-libpng                      \
    -system-freetype

thread_jobs=`getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`

cd ${build_path}
make -j${thread_jobs} && make install
