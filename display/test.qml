import QtQuick 2.15
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0



ApplicationWindow {
    id: root
    visible: true
    color: "#cf97ba"
    width:1280
    height:800
    property var mode: "white"

    Rectangle {
        id: rectangle
        x: 246
        y: 86
        width: 200
        height: 200
        color: "#ffffff"
        MultiPointTouchArea {
               anchors.fill: parent
               onPressed: {console.log('press')}}


        }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
