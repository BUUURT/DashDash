import time
import sys
import os
from os.path import abspath, dirname, join



from PyQt5.QtCore import QObject, QUrl
from PyQt5.QtCore import pyqtSlot as Slot
from PyQt5.QtCore import pyqtSignal as Signal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView

import random

# from style_rc import *

class Bridge(QObject):

    @Slot(result=int)
    def rander(self):
        r = random.randint(0,360)
        return r


    @Slot(result=str)
    def speed(self):
        x = str(time.time())
        y = x.split('.')[1][:2]
        y = float(y)*0.01
        speed = 30.0*y
        speed = str(int(speed))
        return speed


    @Slot(result=int)
    def rpm(self):
        x = str(time.time())
        y = x.split('.')[0][-1:]
        y = float(y)*0.1
        speed = 14000.0*y
        return int(speed)

    @Slot(result=int)
    def spin(self):
        i = str(time.time())
        n = i.split('.')[1][0]
        n = int(n)*36
        return int(n)

if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()


    # Instance of the Python object
    bridge = Bridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("con", bridge)

    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qmlFile = join(dirname(__file__), 'Dash_V8.qml')
#    qmlFile = join(dirname(__file__), 'screentest.qml')
    engine.load(abspath(qmlFile))

    # if not engine.rootObjects():
    #     sys.exit(-1)

    sys.exit(app.exec_())
