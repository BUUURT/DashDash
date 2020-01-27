import sys
import os
from os.path import abspath, dirname, join

from PySide2.QtCore import QObject, Slot, QUrl, Signal
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQuick import QQuickView

import random

# from style_rc import *

class Bridge(QObject):

    @Slot(result=str)
    def speed(self):
        return str(random.randrange(99))

    @Slot(int, result=float)
    def rpm(self, limit):
        limit = float(limit)

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

