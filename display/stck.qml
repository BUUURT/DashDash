import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0
import QtCharts 2.15

ApplicationWindow {
    id: root
    color: root.mainBgColor
    visible: true
    width:1280
    height:800

    Rectangle {
        id: rectangle
        x: 41
        y: 49
        width: 200
        height: 200
        color: "#ffffff"

        ChartView {
            id: line
            x: 35
            y: 54
            width: 300
            height: 300
            LineSeries {
                id: lineSeries
                name: "LineSeries"
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
            //        Timer {
            //            interval: 1000/25
            //            running:true
            //            repeat:true
            //            onTriggered: con.chart(lineSeries)
                    }
        }
    }



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
