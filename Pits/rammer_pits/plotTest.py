import time
import sys
import os
from os.path import abspath, dirname, join
import random
import ast

import PyQt5.QtCore as QtCore
import PyQt5.QtGui as QtGui
import PyQt5.QtQuick as QtQuick
import PyQt5.QtQml as QtQml
from PyQt5.QtCore import QObject, QUrl
from PyQt5.QtCore import pyqtSlot as Slot
from PyQt5.QtCore import pyqtSignal as Signal
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtQuick import QQuickView

from matplotlib.figure import Figure
from matplotlib.backends.backend_agg import FigureCanvasAgg

class MatplotlibImageProvider(QtQuick.QQuickImageProvider):
    figures = dict()

    def __init__(self):
        QtQuick.QQuickImageProvider.__init__(self, QtQml.QQmlImageProviderBase.Image)

    def addFigure(self, name, **kwargs):
        figure = Figure(**kwargs)
        self.figures[name] = figure
        return figure

    def getFigure(self, name):
        return self.figures.get(name, None)

    def requestImage(self, p_str, size):
        figure = self.getFigure(p_str)
        if figure is None:
            return QtQuick.QQuickImageProvider.requestImage(self, p_str, size)

        canvas = FigureCanvasAgg(figure)
        canvas.draw()

        w, h = canvas.get_width_height()
        img = QtGui.QImage(canvas.buffer_rgba(), w, h, QtGui.QImage.Format_RGBA8888).copy()

        return img, img.size()


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Instance of the Python object
    obj = MatplotlibImageProvider()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("con", obj)
    qmlFile = join(dirname(__file__), 'raceViewer.qml')
    engine.load(abspath(qmlFile))
    sys.exit(app.exec_())
