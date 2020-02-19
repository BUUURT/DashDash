import QtQuick 2.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls 2.3

ApplicationWindow {
    id: windowMain
    width: 800
    height: 480
    color: "#b9b9b9"
    visible: true

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered:{
            roter.rotation = con.rander()

        }
    }

        PropertyAnimation {id: animateColor; target: blob; properties: "color"; to: "green"; duration: 100}





    Rectangle {
        id: roter
        x: 200
        y: 200
        transformOrigin: Item.Right
        width: 768
        height: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        rotation: 0


        Behavior on rotation {
            NumberAnimation {
                id: spinnah
                duration: 1000
                easing {
                    type: Easing.OutElastic
                    amplitude: 1
                    period: 1

                }
            }
        }

//        NumberAnimation {
//            id: spinner
//            target: roter
//            properties: 'rotation'
//            from: roter.rotation
//            to: con.rander()
//            easing {type: Easing.OutBack; overshoot: 5}
        }





        Text {
            id: element
            x: 130
            y: 8
            text: roter.rotation
            font.pixelSize: 100
        }




}


/*##^##
Designer {
    D{i:3;anchors_height:30;anchors_width:296;anchors_x:200;anchors_y:200}
}
##^##*/
