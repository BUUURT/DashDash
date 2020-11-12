import time
import sys
import os
from os.path import abspath, dirname, join
import random
import ast

from display.main import uiBoot
from display.bikeClass import Bike
from multiprocessing import Process

#import pyQt5 requests
from PyQt5.QtCore import QObject, QUrl
from PyQt5.QtCore import pyqtSlot as Slot
from PyQt5.QtCore import pyqtSignal as Signal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView

from display import main #UI imports



if __name__=="__main__":
    # app = QGuiApplication(sys.argv)
    # engine = QQmlApplicationEngine()
    # bridge = Bridge()
    # context = engine.rootContext()
    # context.setContextProperty("con", bridge)
    # qmlFile = join(dirname(__file__), 'display/dash_v9.qml')
    # # engine.load(abspath(qmlFile))
    # p1 = Process(target=engine.load,args=qmlFile)
    p1 = Process(target=uiBoot)
    test = Bike(6)
    p2 = Process(target=test.runner)

    p1.start()
    p2.start()

# sys.exit(app.exec_())
