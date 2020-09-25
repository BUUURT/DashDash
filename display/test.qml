import QtQuick 2.0
import QtCharts 2.1

//![1]
LineSeries{
    id: lineSeries
    name: "signal"
    useOpenGL: true
    axisX: ValueAxis {
        id: axisX
        min: 0
        max: 10
    }
    axisY: ValueAxis {
        id: axisY
        min: 0
        max: 100
    }
}
Timer {
    interval: 1000/25
    running: true
    repeat: true
    onTriggered: modelSpectrum.update(lineSeries)
}
