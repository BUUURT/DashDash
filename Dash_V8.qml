import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Window 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtQuick 2.0

ApplicationWindow {
    id: root
    width:800
    height:480
    color: "#262626"
    visible: true
    property int rpm
    property color tachColor: "#4451ff"

    Behavior on rpm {
        NumberAnimation {
            id: rpmAnimation2
            duration: 3000
            easing {
                type: Easing.OutElastic
                amplitude: 2
                period: 1
            }
        }
    }


    onRpmChanged: {
        element.text = root.rpm;
        sweepLow.rotation = root.rpm <= 5000 ? root.rpm*90/5000 : 90
        sweepHigh.width = root.rpm > 5000 ? (root.rpm-5000)*612/9000 : 0


        shift_a.opacity = root.rpm > 8000 ? 1.0 : 0.05
        shift_b.opacity = root.rpm > 9000 ? 1.0 : 0.05
        shift_c.opacity = root.rpm > 10000 ? 1.0 : 0.05
        shift_d.opacity = root.rpm > 11000 ? 1.0 : 0.05
        shift_e.opacity = root.rpm > 12000 ? 1.0 : 0.05

    }

    Rectangle {
        id: sweepHigh
        x: 177
        y: 25
        width: 200
        height: 200
        color: root.tachColor
    }

    Rectangle {
        id: sweepLow
        x: -83
        y: 278
        width: 263
        height: 248
        color: "#4451ff"
        transformOrigin: Item.TopRight
        rotation: 90

        Behavior on rotation {
            NumberAnimation {
                id: rpmAnimation
                duration: 5
                easing {
                    type: Easing.OutElastic
                    amplitude: 1
                    period: 1
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
                onTriggered: {
                    root.rpm = con.rpm()
    }
    }




    Image {
        id: rpmhole
        source: "images/rpmhole.png"
        x: 0
        y: 0
        opacity: 1

    }


//    Dial {
//        id: dial
//        x: 556
//        y: 258
//        background: Rectangle {
//            x: dial.width / 2 - width / 2
//            y: dial.height / 2 - height / 2
//            width: Math.max(64, Math.min(dial.width, dial.height))
//            height: width
//            color: "gray"
//            radius: width/2
//            border.color: dial.pressed ? "red" : "blue"
//            border.width: 5
//            opacity: dial.enabled ? 1 : 0.3
//        }
//        onValueChanged: {
////            root.rpm = value*14000

//        }
//    }

    Image {
        id: labels
        source: "images/labels.png"
        x: 52
        y: 155
        opacity: 1
    }
    Image {
        id: shift_a
        source: "images/shift_a.png"
        x: 0
        y: 0
        opacity: 1
    }
    Image {
        id: shift_b
        source: "images/shift_b.png"
        x: 88
        y: 0
        opacity: 1
    }
    Image {
        id: shift_c
        source: "images/shift_c.png"
        x: 177
        y: 0
        opacity: 1
    }
    Image {
        id: shift_d
        source: "images/shift_d.png"
        x: 266
        y: 0
        opacity: 1
    }
    Image {
        id: shift_e
        source: "images/shift_e.png"
        x: 355
        y: 0
        opacity: 1
    }




    Text {
        id: element
        x: 475
        y: 181
        color: "#f7f7f7"
        text: qsTr("Text")
        font.pixelSize: 53
    }





}






