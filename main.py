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

    @Slot(result=str)
    def speed(self):

        return str(time.time()).split('.')[1][:2]

    @Slot(int, result=float)
    def rpm(self, limit):
        limit = limit
        speed = str(time.time()).split('.')[1][0]

        speed = int(speed)+4
#        print(speed)


        if limit > speed:
            return float(0.1)
        if limit <= speed:
            return float(1.0)


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
    qmlFile = join(dirname(__file__), 'root.qml')
    engine.load(abspath(qmlFile))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
