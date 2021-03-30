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

from bikeClass import Bike

bike = Bike(_wheelspeed=False, _rpm=False,_gps=False,_imu=False,_engtemp=False)

class Bridge(QObject):


    # @Slot(result=str)
    # def bikeLean(self):
    #     #return bike.imu_y
    #     return str(0)

    @Slot(result=str)
    def airTemp(self):
        #return bike.airTemp
        return '0'

    @Slot(result=str)
    def speed(self):
        #return str(bike.speedCalc())
        return '0'

    @Slot(result=int)
    def rpm(self):
        #return bike.rpmCalc()
        i = str(time.time()).split('.')
        elm = i[0][-1:]+i[1][:2]
        r = int(elm)*13000/999
        r = int(r)
        return r

    @Slot(result=int)
    def lean(self):
        #return bike.imu.euler[1]
        return 0

    @Slot(result=int)
    def accelX(self):
        # return bike.imu.acceleration[0]
        return 0

    @Slot(result=int)
    def accelY(self):
        #return bike.imu.acceleration[1]
        return 0

    @Slot(result=str)
    def clock(self):
        return  str(datetime.datetime.now().strftime("%H:%M"))



#    @Slot(str, result=str)
#    def raceTimeData(self,value):
#        data = requests.get(r'http://192.168.254.12:9000/dashGet')
#        data = ast.literal_eval(data.text)
#        return data[value]


if __name__ == '__main__':

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Instance of the Python object
    bridge = Bridge()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("con", bridge)
    qmlFile = join(dirname(__file__), 'display/dash_v9.qml')
    engine.load(abspath(qmlFile))
    sys.exit(app.exec_())
