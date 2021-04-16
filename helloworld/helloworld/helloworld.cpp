/**
 * 
 * Release under GPLv-3.0.
 * 
 * @file    helloworld.cpp
 * @brief   
 * @author  gnsyxiang <gnsyxiang@163.com>
 * @date    15/04 2021 11:05
 * @version v0.0.1
 * 
 * @since    note
 * @note     note
 * 
 *     change log:
 *     NO.     Author              Date            Modified
 *     00      zhenquan.qiu        15/04 2021      create the file
 * 
 *     last modified: 15/04 2021 11:05
 */
#include <QApplication>
#include <QWidget>
#include <QLabel>

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);

    QWidget w;
    w.resize(400, 400);
    w.setWindowTitle("hello world");

    QLabel textLabel;
    textLabel.resize(100,15);
    textLabel.move(150, 170);
    textLabel.setText("hello world");
    textLabel.setParent(&w);
    textLabel.show();

    w.show();
    return app.exec();
}

