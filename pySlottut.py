from PySide import QtCore, QtGui, QtDeclarative

if __name__ == '__main__':
    import sys

    app = QtGui.QApplication(sys.argv)

    timer = QtCore.QTimer()
    timer.start(2000)

    view = QtDeclarative.QDeclarativeView()
    view.setSource(QtCore.QUrl('view.qml'))
    root = view.rootObject()

    timer.timeout.connect(root.updateRotater)

    view.show()

    sys.exit(app.exec_())# This Python file uses the following encoding: utf-8

# if__name__ == "__main__":
#     pass
