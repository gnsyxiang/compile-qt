# 屏幕旋转

qt5没有像qt4那样提供linuxfb旋转的功能

## 源码修改

### 修改的源码如下

src/plugins/platforms/linuxfb/qlinuxfbscreen.cpp

```cpp
diff --git a/src/plugins/platforms/linuxfb/qlinuxfbscreen.cpp b/src/plugins/platforms/linuxfb/qlinuxfbscreen.cpp
index dc7ea08d..b85e4bd1 100644
--- a/src/plugins/platforms/linuxfb/qlinuxfbscreen.cpp
+++ b/src/plugins/platforms/linuxfb/qlinuxfbscreen.cpp
@@ -287,7 +287,7 @@ static void blankScreen(int fd, bool on)
 }
 
 QLinuxFbScreen::QLinuxFbScreen(const QStringList &args)
-    : mArgs(args), mFbFd(-1), mTtyFd(-1), mBlitter(0)
+    : mArgs(args), mFbFd(-1), mTtyFd(-1), mBlitter(0), mRotation(90)
 {
     mMmap.data = 0;
 }
@@ -313,6 +313,7 @@ bool QLinuxFbScreen::initialize()
     QRegularExpression mmSizeRx(QLatin1String("mmsize=(\\d+)x(\\d+)"));
     QRegularExpression sizeRx(QLatin1String("size=(\\d+)x(\\d+)"));
     QRegularExpression offsetRx(QLatin1String("offset=(\\d+)x(\\d+)"));
+    QRegularExpression rotationRx(QLatin1String("rotation=(0|90|180|270)"));
 
     QString fbDevice, ttyDevice;
     QSize userMmSize;
@@ -334,6 +335,8 @@ bool QLinuxFbScreen::initialize()
             ttyDevice = match.captured(1);
         else if (arg.contains(fbRx, &match))
             fbDevice = match.captured(1);
+        else if (arg.contains(rotationRx, &match))
+            mRotation = match.captured(1).toInt();
     }
 
     if (fbDevice.isEmpty()) {
@@ -372,9 +375,17 @@ bool QLinuxFbScreen::initialize()
     mDepth = determineDepth(vinfo);
     mBytesPerLine = finfo.line_length;
     QRect geometry = determineGeometry(vinfo, userGeometry);
+
+    QRect originalGeometry = geometry;
+    if( mRotation == 90 || mRotation == 270 )
+    {
+        int tmp = geometry.width();
+        geometry.setWidth(geometry.height());
+        geometry.setHeight(tmp);
+    }
     mGeometry = QRect(QPoint(0, 0), geometry.size());
     mFormat = determineFormat(vinfo, mDepth);
-    mPhysicalSize = determinePhysicalSize(vinfo, userMmSize, geometry.size());
+    mPhysicalSize = determinePhysicalSize(vinfo, userMmSize, originalGeometry.size());
 
     // mmap the framebuffer
     mMmap.size = finfo.smem_len;
@@ -384,11 +395,11 @@ bool QLinuxFbScreen::initialize()
         return false;
     }
 
-    mMmap.offset = geometry.y() * mBytesPerLine + geometry.x() * mDepth / 8;
+    mMmap.offset = originalGeometry.y() * mBytesPerLine + originalGeometry.x() * mDepth / 8;
     mMmap.data = data + mMmap.offset;
 
     QFbScreen::initializeCompositor();
-    mFbScreenImage = QImage(mMmap.data, geometry.width(), geometry.height(), mBytesPerLine, mFormat);
+    mFbScreenImage = QImage(mMmap.data, originalGeometry.width(), originalGeometry.height(), mBytesPerLine, mFormat);
 
     mCursor = new QFbCursor(this);
 
@@ -413,8 +424,26 @@ QRegion QLinuxFbScreen::doRedraw()
         mBlitter = new QPainter(&mFbScreenImage);
 
     mBlitter->setCompositionMode(QPainter::CompositionMode_Source);
-    for (const QRect &rect : touched)
-        mBlitter->drawImage(rect, mScreenImage, rect);
+    // for (const QRect &rect : touched)
+        // mBlitter->drawImage(rect, mScreenImage, rect);
+
+     QVector<QRect> rects = touched.rects();
+     for (int i = 0; i < rects.size(); i++) {
+        if( mRotation == 90 || mRotation == 270 ) {
+            mBlitter->translate(mGeometry.height()/2, mGeometry.width()/2);
+        } else if( mRotation == 180 ) {
+            mBlitter->translate(mGeometry.width()/2, mGeometry.height()/2);
+        }
+
+        if( mRotation != 0 ) {
+            mBlitter->rotate(mRotation);
+            mBlitter->translate(-mGeometry.width()/2, -mGeometry.height()/2);
+        }
+
+        mBlitter->drawImage(rects[i], mScreenImage, rects[i]);
+
+        mBlitter->resetTransform();
+    }
 
     return touched;
 }
```

src/plugins/platforms/linuxfb/qlinuxfbscreen.h

```cpp
diff --git a/src/plugins/platforms/linuxfb/qlinuxfbscreen.h b/src/plugins/platforms/linuxfb/qlinuxfbscreen.h
index c7ce455e..385d29c3 100644
--- a/src/plugins/platforms/linuxfb/qlinuxfbscreen.h
+++ b/src/plugins/platforms/linuxfb/qlinuxfbscreen.h
@@ -64,6 +64,7 @@ private:
     QStringList mArgs;
     int mFbFd;
     int mTtyFd;
+    int mRotation;
 
     QImage mFbScreenImage;
     int mBytesPerLine;
```

### git path文件如下

git根目录创建在qtbase

[0001-feat-screen-rotation-patch-for-qt5.12.10.patch](0001-feat-screen-rotation-patch-for-qt5.12.10.patch)

### 重新编译源码

生成对应的库为`plugins/platforms/libqlinuxfb.so`



## 启动设置

* 设置环境变量

```shell
export QT_QPA_PLATFORM="linuxFB:fb=/dev/fb0:size=800x1280:mmSize=800x1280:offset=0x0:rotation=90"
```

* 添加运行程序参数

```shell
./app -platform linuxFB:fb=/dev/fb0:size=800x1280:mmSize=800x1280:offset=0x0:rotation=90
```


## 触摸旋转


