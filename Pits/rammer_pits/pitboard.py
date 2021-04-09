import time
import sys
import os
from os.path import abspath, dirname, join
import random
import ast

import datetime

#import requests

from PyQt5.QtCore import QObject, QUrl
from PyQt5.QtCore import pyqtSlot as Slot
from PyQt5.QtCore import pyqtSignal as Signal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView

class Pitboard(QObject):
    @Slot(result=str)
    def test(self):
        return 'nice'


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Instance of the Python object
    pitboard = Pitboard()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("con", pitboard)
    qmlFile = join(dirname(__file__), 'raceViewer.qml')
    engine.load(abspath(qmlFile))
    sys.exit(app.exec_())
