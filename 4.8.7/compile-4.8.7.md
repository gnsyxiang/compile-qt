# 编译4.8.7版本

<!-- vim-markdown-toc GFM -->

- [进行影子编译(shadow build)](#进行影子编译shadow-build)
- [从源码`README`开始](#从源码readme开始)
- [安装相关依赖](#安装相关依赖)
- [编译`ubuntu`版本](#编译ubuntu版本)
  - [修改源码配置项](#修改源码配置项)
  - [增加`ccache`加快二次编译速度](#增加ccache加快二次编译速度)
  - [编译脚本](#编译脚本)
- [交叉编译`himix200`版本](#交叉编译himix200版本)
  - [增加平台配置项](#增加平台配置项)
  - [选择编译工具链路径](#选择编译工具链路径)
  - [增加`ccache`加快二次编译速度](#增加ccache加快二次编译速度-1)
  - [编译脚本](#编译脚本-1)

<!-- vim-markdown-toc -->

## 进行影子编译(shadow build)

建立一个空的目录，用于配置和编译源码，避免污染源码目录

```shell
mkdir -p /mnt/data/build/qt/4.8.7/build-ubuntu
build.sh
```
## 从源码`README`开始

解压源码

```shell
/mnt/xia/qt/4.8.7$ ls
qt-everywhere-opensource-src-4.8.7.tar.gz
/mnt/xia/qt/4.8.7$ tar xzvf qt-everywhere-opensource-src-4.8.7.tar.gz -C /mnt/data/build/qt/qt-everywhere-opensource-src-4.8.7
```

源码目录下`README`

![README](img/README.png)

源码目录下`INSTALL`

![INSTALL](img/INSTALL.png)

URL: [编译各个平台](http://qt-project.org/doc/qt-4.8/installation.html)

![install-all-platform](img/install-all-platform.png)

URL: [安装X11平台的依赖库](https://doc.qt.io/archives/qt-4.8/requirements-x11.html)

![requirement_for_x11](img/requirement_for_x11.png)

URL: [编译X11平台](http://qt-project.org/doc/qt-4.8/install-x11.html)

![install_for_x11](img/install_for_x11.png)

## 安装相关依赖

* QtGui依赖项(QtGui Dependencies)

![qtgui-dependencies](img/qtgui-dependencies.png)

recommend install packages:

```shell
$ sudo apt install -y libfontconfig1-dev libfreetype6-dev libx11-dev libxcursor-dev libxext-dev libxfixes-dev libxft-dev libxi-dev libxrandr-dev libxrender-dev
```

* OpenGL依赖项(OpenGL Dependencies)

    * 安装`C/C++`编译环境

    ```shell
    $ sudo apt install -y build-essential
    ```

    * OpenGL核心库，GL

    ```shell
    $ sudo apt install -y libgl1-mesa-dev
    $ sudo apt install -y libgles2-mesa-dev  # 嵌入式平台
    ```

    * OpenGL实用函数库，GLU

    ```shell
    $ sudo apt install -y libglu1-mesa-dev
    ```

    * OpenGL实用工具包，GLUT

    ```shell
    $ sudo apt install -y freeglut3-dev
    ```

    * 额外安装的包

    ```shell
    $ sudo apt install -y libglew-dev libsdl2-dev libsdl2-image-dev libglm-dev libfreetype6-dev libglfw3-dev libglfw3
    ```

    ```shell
    # 整合在一起方便安装
    $ sudo apt install -y build-essential libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libglew-dev libsdl2-dev libsdl2-image-dev libglm-dev libfreetype6-dev libglfw3-dev libglfw3
    ```

* 多媒体相关性(Phonon Dependencies)

```shell
$ sudo apt install -y libgstreamer1.0-0
$ sudo apt install -y gstreamer1.0-plugins-base
$ sudo apt install -y gstreamer1.0-plugins-good
$ sudo apt install -y gstreamer1.0-plugins-bad
$ sudo apt install -y gstreamer1.0-plugins-ugly
$ sudo apt install -y gstreamer1.0-libav
$ sudo apt install -y gstreamer1.0-doc
$ sudo apt install -y gstreamer1.0-tools
$ sudo apt install -y gstreamer1.0-x
$ sudo apt install -y gstreamer1.0-alsa
$ sudo apt install -y gstreamer1.0-gl
$ sudo apt install -y gstreamer1.0-gtk3
$ sudo apt install -y gstreamer1.0-qt5
$ sudo apt install -y gstreamer1.0-pulseaudio

# 整合在一起方便安装
$ sudo apt install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
```

## 编译`ubuntu`版本

### 修改源码配置项

报错
```txt
qt-everywhere-opensource-src-4.8.7/src/3rdparty/javascriptcore/JavaScriptCore/wtf/TypeTraits.h:173:69: error: ‘std::tr1’ has not been declared
```

解决
```
vi mkspecs/common/g++-base.conf

QMAKE_CXX = g++ -std=gnu++98
```


### 增加`ccache`加快二次编译速度

* 安装软件

```shell
$ sudo apt install -y ccache
```

首次编译时间:

```shell
$ time make -j12

real	20m54.295s
user	83m22.575s
sys	15m29.169s
```

第二次编译:

```shell
$ make clean
$ time make -j12
real	4m1.788s
user	15m51.252s
sys	    2m7.086s
```

* 修改源码配置项

修改文件`mkspecs/common/g++-base.conf`

![g++-base-ccache](img/g++-base-ccache.png)

### 编译脚本

详见[`build-ubuntu.sh`](build-ubuntu.sh)脚本



## 交叉编译`himix200`版本

### 增加平台配置项

增加如下目录`mkspecs/qws/linux-arm-himix200-g++`

```
cp -ar linux-arm-himix200-g++ mkspecs/qws/linux-arm-himix200-g++
```

[内容详见](linux-arm-himix200-g++)

### 选择编译工具链路径

![linux-arm-himix200-g++](img/linux-arm-himix200-g++.png)

### 增加`ccache`加快二次编译速度

![linux-arm-himix200-g++-ccache](img/linux-arm-himix200-g++-ccache.png)

### 编译脚本

详见[`build-hisi.sh`](build-hisi.sh)脚本


