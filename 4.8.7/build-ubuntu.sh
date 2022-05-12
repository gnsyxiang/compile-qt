#!/usr/bin/env bash

function usage()
{
    echo "eg: ./build.sh src-path [/mnt/soft/ubuntu/usr/local] [/mnt/data/build/qt/4.8.7/build-ubuntu]"
    exit
}

if [ $# -lt 1 -o  $# -gt 3 ]; then
    usage
elif [ $# -eq 1 ]; then
    install_path=/mnt/soft/ubuntu/usr/local
    build_path=/mnt/data/build/qt/4.8.7/build-ubuntu
elif [ $# -eq 2 ]; then
    install_path=$2
    build_path=/mnt/data/build/qt/4.8.7/build-ubuntu
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
    -system-freetype

thread_jobs=`getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`

cd ${build_path}
make -j${thread_jobs} && make install


