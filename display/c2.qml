import QtQuick 2.0
import QtQuick.Window 2.15
import QtCharts 2.15


Window {
    visible:true
    width: 640
    height: 480
    title:qsTr('words')

    ChartView {
        id: line
        x: 71
        y: 102
        width: 300
        height: 300
        LineSeries {
            name: "LineSeries"
            XYPoint {
                x: 0
                y: 2
            }

            XYPoint {
                x: 1
                y: 1.2
            }

            XYPoint {
                x: 2
                y: 3.3
            }

            XYPoint {
                x: 5
                y: 2.1
            }
        }
    }



}
