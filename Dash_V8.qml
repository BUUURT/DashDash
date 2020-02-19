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
    color: "#181616"
    visible: true
    property int rpm
    property int speed
    property color tachColor: "white"

    Behavior on speed {
        NumberAnimation {
            id: speedani
            duration: 1000
            easing {
                type: Easing.InOutExpo
                amplitude: 2
                period: 1
            }
        }
    }

    Behavior on rpm {
        NumberAnimation {
            id: rpmAnimation2
            duration: 1500
            easing {
                type: Easing.InOutExpo
                amplitude: 2
                period: 1
            }
        }
    }


    onRpmChanged: {
        lapDisp.text = root.rpm;
        sweepLow.rotation = root.rpm <= 5000 ? root.rpm*90/5000 : 90
        sweepHigh.width = root.rpm > 5000 ? (root.rpm-5000)*612/9000 : 0


//        shift_a.opacity = root.rpm > 8000 ? 1.0 : 0.05
//        shift_b.opacity = root.rpm > 9000 ? 1.0 : 0.05
//        shift_c.opacity = root.rpm > 10000 ? 1.0 : 0.05
//        shift_d.opacity = root.rpm > 11000 ? 1.0 : 0.05
//        shift_e.opacity = root.rpm > 12000 ? 1.0 : 0.05



        rpmLabel0.font.pixelSize = (0 < root.rpm && root.rpm < 1000) ? 35 : 15
        rpmLabel1.font.pixelSize = (1000 < root.rpm && root.rpm < 2000) ? 35 : 15
        rpmLabel2.font.pixelSize = (2000 < root.rpm && root.rpm < 3000) ? 35 : 15
        rpmLabel3.font.pixelSize = (3000 < root.rpm && root.rpm < 4000) ? 35 : 15
        rpmLabel4.font.pixelSize = (4000 < root.rpm && root.rpm  < 5000) ? 35 : 15
        rpmLabel5.font.pixelSize = (5000 < root.rpm && root.rpm < 6000) ? 35 : 15
        rpmLabel6.font.pixelSize = (6000 < root.rpm && root.rpm < 7000) ? 35 : 15
        rpmLabel7.font.pixelSize = (7000 < root.rpm && root.rpm  < 8000) ? 35 : 15
        rpmLabel8.font.pixelSize = (8000 < root.rpm && root.rpm  < 9000) ? 35 : 15
        rpmLabel9.font.pixelSize = (9000 < root.rpm && root.rpm  < 10000) ? 35 : 15
        rpmLabel10.font.pixelSize = (10000 < root.rpm && root.rpm  < 11000) ? 35 : 15
        rpmLabel11.font.pixelSize = (11000 < root.rpm && root.rpm  < 12000) ? 35 : 15
        rpmLabel12.font.pixelSize = (12000 < root.rpm && root.rpm  < 13000) ? 35 : 15
        rpmLabel13.font.pixelSize = (13000 < root.rpm && root.rpm < 14000) ? 35 : 15

        if (root.rpm < 7000) {
            shiftLeft.width = 0
            shiftRight.width = 0
        }

        if (root.rpm > 7000) {
            shiftLeft.width = (root.rpm-7000) * 4/50
            shiftRight.width = (root.rpm-7000) * 4/50
        }

        if (root.rpm < 9500) {
            shiftLeft.color = "#00ff00"
            shiftRight.color = "#00ff00"
        }

        if (root.rpm > 9500) {
            shiftLeft.color = "#ffff00"
            shiftRight.color = "#ffff00"
        }
        if (root.rpm > 11500) {
            shiftLeft.color = "#ff0000"
            shiftRight.color = "#ff0000"
        }

        if (root.rpm < 11500) {
            shiftLeft.color = "#ffff00"
            shiftRight.color = "#ffff00"
        }

    }

    onSpeedChanged: {
        speedprint.text = root.speed
    }

    Rectangle {
        id: sweepHigh
        x: 177
        y: 25
        width: 0
        height: 200
        color: root.tachColor
    }

    Rectangle {
        id: sweepLow
        x: -86
        y: 278
        width: 263
        height: 248
        color: root.tachColor
        transformOrigin: Item.TopRight
        rotation: 0
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
                onTriggered: {
                    root.rpm = con.rpm()
                    root.speed = con.speed()
                }
    }




    Image {
        id: rpmhole
        source: "images/rpmhole.png"
        x: 0
        y: 0
        opacity: 1

        Rectangle {
            id: shiftLeft
            x: 0
            y: 0
            width: 0
            height: 50
            color: "#00ff00"
        }

        Rectangle {
            id: shiftRight
            x: 600
            y: 0
            width: 0
            height: 50
            color: "#00ff00"
            anchors.right: parent.right
            anchors.rightMargin: 0

        }

        Text {
            id: engineTemp
            x: 27
            y: 325
            color: "#ffffff"
            text: qsTr("150F")
            font.pixelSize: 30
        }

        Text {
            id: braketemp
            x: 27
            y: 395
            color: "#ffffff"
            text: qsTr("100F")
            font.pixelSize: 30
        }

        Text {
            id: lapDisp
            x: 382
            y: 213
            width: 189
            height: 87
            color: "#ffffff"
            text: qsTr("45:00")
            font.pixelSize: 70
        }

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

        Text {
            id: rpmLabel0
            x: 13
            y: 103
            color: "#ffffff"
            text: qsTr("0")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel1
            x: 20
            y: 72
            color: "#ffffff"
            text: qsTr("1")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation2
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel2
            x: 32
            y: 46
            color: "#ffffff"
            text: qsTr("2")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation3
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel3
            x: 49
            y: 25
            color: "#ffffff"
            text: qsTr("3")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation4
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel4
            x: 82
            y: 13
            color: "#ffffff"
            text: qsTr("4")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation5
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel5
            x: 111
            y: 8
            color: "#ffffff"
            text: qsTr("5")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation6
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel6
            x: 180
            y: 8
            color: "#ffffff"
            text: qsTr("6")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation7
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel7
            x: 249
            y: 8
            color: "#ffffff"
            text: qsTr("7")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation8
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel8
            x: 318
            y: 8
            color: "#ffffff"
            text: qsTr("8")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation9
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel9
            x: 387
            y: 8
            color: "#ffffff"
            text: qsTr("9")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation10
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel10
            x: 456
            y: 8
            color: "#ffffff"
            text: qsTr("10")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation11
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel11
            x: 524
            y: 8
            color: "#ffffff"
            text: qsTr("11")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation12
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel12
            x: 594
            y: 8
            color: "#ffffff"
            text: qsTr("12")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation13
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel13
            x: 661
            y: 8
            color: "#ffffff"
            text: qsTr("13")
            font.pixelSize: 20
            Behavior on font.pixelSize {
                NumberAnimation {
                    id: fontAnimation14
                    duration: 500
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1
                    }
                }
            }
        }

        Text {
            id: rpmLabel14
            x: 733
            y: 8
            color: "#ffffff"
            text: qsTr("14")
            font.pixelSize: 20
        }

        Rectangle {
            id: speedBG
            x: 58
            y: 46
            width: 243
            height: 240
            color: "#131313"
            radius: 36
            border.color: "#181812"

            Text {
                id: speedprint
                x: 78
                y: 85
                color: "#ffffff"
                text: qsTr("00")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 200
            }
        }

        Text {
            id: raceplace
            x: 631
            y: 72
            color: "#ffffff"
            text: qsTr("P18")
            font.pixelSize: 50
        }

        Text {
            id: timeAbove
            x: 329
            y: 147
            color: "#ffffff"
            text: qsTr("00:00")
            font.pixelSize: 50
        }

        Text {
            id: raceplace2
            x: 631
            y: 139
            color: "#ffffff"
            text: qsTr("L100")
            font.pixelSize: 50
        }

        Text {
            id: timeAbove1
            x: 329
            y: 201
            color: "#ffffff"
            text: qsTr("00:00")
            font.pixelSize: 50
        }
    }








}






