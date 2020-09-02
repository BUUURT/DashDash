import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0



ApplicationWindow {
    id: root
    color: mainBgColor
    visible: true
    width:1280
    height:800

    property color mainFontColor: "black"
    property color mainBgColor: "white"
    property color mainBgColorSub: "#eaeaea"
    property color mainAccentColor: "darkblue"
    property int rpm: 0
    property int speed: 0
    property color rpmColor: "#4d6278"
    property int shiftLow: 11000
    property int shiftHigh: 12200

    Rectangle {
        id: rpmSweepLow
        y: 312
        width: 122
        height: 220
        color: root.rpmColor
        anchors.left: parent.left
        anchors.leftMargin: 37
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 288
        opacity: 1
        rotation: 0
        transformOrigin: Item.Top
    }

    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            root.rpm = con.rpm()
            root.speed = con.speed()

            //positionNumber.text = con.raceTimeData('selfPosition')
            //lapNumber.text = con.raceTimeData('selfLaps')
            //lapTimeSelf.text = con.raceTimeData('selfLaptime')
            //positionNumber.text = '2'
            //lapNumber.text = '123'
            //lapTimeSelf.text = '0:49.431'


        }
    }

    Behavior on rpm {
        NumberAnimation { properties: "rpm"; duration: 1000 }

    }



    onRpmChanged: {
        // drive RPM animation
        if (rpm<6000) {
            rpmSweepMid.visible = false
            rpmSweepLow.height = rpm*220/6000
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
        }

        if (rpm>6000 && rpm<7000) {
            rpmSweepLow.height = 220
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = (rpm-6000)*9/100
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
        }

        if (rpm>7000 && rpm <11000) {
            rpmSweepLow.height = 220
            rpmSweepHigh.visible = true
            rpmSweepMid.rotation = 90
            rpmSweepHigh.width = (rpm-7000)*99/600
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
        }

        if (rpm>11000 && rpm<12000) {
            rpmSweepHigh.width = 660
            rpmSweepOrange.visible = true
            rpmSweepRed.visible = false
            rpmSweepOrange.width = (rpm-11000)*0.168
        }

        if (rpm>12000) {
            rpmSweepHigh.width = 660
            rpmSweepRed.visible = true
            rpmSweepRed.width = (rpm-12000)*.168
        }

        // set color and behavior of shift light
        var rpmGreen = parseInt(root.shiftGreen)
        var rpmYellow = parseInt(root.shiftYellow)
        var rpmRed = parseInt(root.shiftRed)
        var rpmFlash = parseInt(root.shiftRedFlash)

        //        if (rpm < rpmGreen) {rpmColor = "#4d6278"}  // out of powerband, blue RPM
        //        if (rpm < rpmYellow && rpm > rpmGreen) {rpmColor = "#00ff00"}  //start powerband, green
        //        if (rpm < rpmRed && rpm > rpmYellow) {rpmColor = "#ffff00"} //yellow
        //        if (rpm > rpmRed) {rpmColor = "#ff0000"} //red

        //adjust rpm font label size
        //        label0.font.pixelSize = (0 < root.rpm && root.rpm < 1000) ? 20 : 15

        //        speed.text = root.speed



    }

    onSpeedChanged: {
        speed.text = root.speed
    }


    Rectangle {
        id: rpmSweepMid
        x: -67
        y: 292
        width: 329
        height: 207
        color: root.rpmColor
        visible: true
        z: 0
        rotation: 90
        transformOrigin: Item.TopRight
    }








    Rectangle {
        id: rpmSweepHigh
        y: 9
        width: 990
        height: 145
        color: root.rpmColor
        anchors.left: parent.left
        anchors.leftMargin: 262
        transformOrigin: Item.Center
    }

    Rectangle {
        id: rpmSweepOrange
        x: 524
        y: 9
        width: 166
        height: 145
        color: "#ff9000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.leftMargin: 916
    }


    Rectangle {
        id: rpmSweepRed
        x: 523
        y: 9
        width: 170
        height: 145
        color: "#ff0000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.leftMargin: 1082
    }



    Image {
        id: baselayer
        source: "dashV9.png"
        x: 0
        y: 0
        width: 1280
        height: 800
        opacity: 1

        Text {
            id: speed
            x: 317
            y: 237
            text: qsTr("61")
            font.bold: true
            font.family: "Arial"
            font.pixelSize: 300

            Text {
                id: speedLabel
                x: 135
                y: 271
                text: qsTr("MPH")
                font.family: "BN Elements"
                font.pixelSize: 36
            }
        }

        Rectangle {
            id: tempEngBg
            x: 115
            y: 703
            width: 160
            height: 80
            color: "#00ff00"
            radius: 25
            border.width: 2

            Text {
                id: tempEngDisp
                text: qsTr("175")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 55
            }

            Text {
                id: tempEngLabel
                text: qsTr("ENG")
                font.family: "BN Elements"
                anchors.right: parent.left
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40
            }

            Text {
                id: tempEngLabel2
                x: 4
                y: -4
                text: qsTr("ENG")
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                font.family: "BN Elements"
                anchors.right: parent.left
                font.pixelSize: 40
            }
        }

        Rectangle {
            id: tempBrakeBg
            y: 712
            width: 160
            height: 80
            color: "#ff9000"
            radius: 25
            anchors.left: tempEngBg.right
            anchors.leftMargin: 130
            anchors.verticalCenter: tempEngBg.verticalCenter
            border.width: 2
            Text {
                id: tempBrakeDisp
                text: qsTr("450")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 55
            }

            Text {
                id: tempBrakeLabel
                text: qsTr("BRK")
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                font.family: "BN Elements"
                anchors.right: parent.left
                font.pixelSize: 40
            }
        }

        Rectangle {
            id: posBg
            x: 720
            y: 296
            width: 125
            height: 90
            color: "#ffffff"
            radius: 25
            Text {
                id: posDisp
                text: qsTr("11")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 75
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: posLabel
                text: qsTr("POS")
                anchors.bottom: parent.top
                anchors.bottomMargin: -8
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 30
                font.family: "BN Elements"
            }
            border.width: 2
        }

        Rectangle {
            id: lapBg
            y: 415
            width: 125
            height: 90
            color: "#ffffff"
            radius: 25
            anchors.left: posBg.right
            anchors.leftMargin: 35
            anchors.verticalCenter: posBg.verticalCenter
            Text {
                id: lapDisp
                width: 130
                text: qsTr("114")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 75
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: lapLabel
                text: qsTr("LAP")
                anchors.bottom: parent.top
                anchors.bottomMargin: -8
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 30
                font.family: "BN Elements"
            }
            border.width: 2
        }

        Rectangle {
            id: sesTBg
            x: 0
            y: 419
            width: 225
            height: 90
            color: "#ffffff"
            radius: 25
            Text {
                id: sesTDisp
                text: qsTr("20:45")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 75
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: sesTlabel
                text: qsTr("RACE CLOCK")
                anchors.bottom: parent.top
                font.pixelSize: 30
                font.family: "BN Elements"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: -8
            }
            anchors.verticalCenter: lapBg.verticalCenter
            anchors.leftMargin: 35
            anchors.left: lapBg.right
            border.width: 2
        }

        Rectangle {
            id: lastLapBg
            x: 722
            width: 350
            height: 100
            color: "#ffffff"
            radius: 25
            anchors.top: posBg.bottom
            anchors.topMargin: 40
            Text {
                id: lastLapDisp
                text: qsTr("0:45.14")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 95
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: lastLapLabel
                text: qsTr("LAST LAP")
                anchors.bottom: parent.top
                font.pixelSize: 30
                font.family: "BN Elements"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: -8
            }
            anchors.leftMargin: 0
            anchors.left: posBg.left
            border.width: 2
        }

        Rectangle {
            id: tcSlipBg
            x: 887
            y: 628
            width: 80
            height: 65
            color: "#2b82dc"
            radius: 5
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: tempEngBg.verticalCenter
            Text {
                id: tcSlipDisp
                text: qsTr("5")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: tcSlipLabel
                text: qsTr("SLIP")
                font.letterSpacing: 5
                font.italic: false
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 60
                anchors.right: parent.left
                font.family: "BN Elements"
            }
            border.width: 2
        }

        Rectangle {
            id: tcCutBg
            y: 714
            width: 80
            height: 80
            color: "#ffff00"
            radius: 5
            anchors.left: tcSlipBg.right
            anchors.leftMargin: 195
            anchors.verticalCenter: tcSlipBg.verticalCenter
            Text {
                id: tcCutDisp
                text: qsTr("3")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 60
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: tcCutLabel
                text: qsTr("CUT")
                font.letterSpacing: 1
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 60
                anchors.right: parent.left
                font.family: "BN Elements"
            }
            border.width: 2
        }

        Rectangle {
            id: lastDeltaBg
            x: 718
            y: 6
            width: 185
            height: 100
            color: "#00ff00"
            radius: 25
            anchors.topMargin: 40
            Text {
                id: lastDeltaDisp
                text: qsTr("+5.45")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 65
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: lastDeltaLabel
                text: qsTr("DELTA")
                anchors.bottom: parent.top
                font.pixelSize: 30
                font.family: "BN Elements"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: -8
            }
            anchors.leftMargin: 11
            anchors.left: lastLapBg.right
            border.width: 2
            anchors.top: posBg.bottom
        }

        Text {
            id: teamMsg
            x: 8
            y: 538
            width: 696
            height: 151
            text: qsTr("PIT 5L")
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 125
        }

        Image {
            id: teamUpLabel
            width: 60
            height: 60
            anchors.top: lastLapBg.bottom
            anchors.topMargin: 18
            anchors.left: posBg.left
            anchors.leftMargin: 0
            fillMode: Image.PreserveAspectFit
            source: "images/triangle.png"

            Rectangle {
                id: upTeamNumBg
                x: 72
                y: -166
                width: 130
                height: 60
                color: "#ffffff"
                radius: 10
                anchors.left: parent.right
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                border.width: 2

                Text {
                    id: upTeamNumDisp
                    text: qsTr("#666")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
            }

            Rectangle {
                id: upTeamLapBg
                x: 72
                y: -175
                width: 140
                height: 60
                color: "#ffffff"
                radius: 10
                border.width: 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: upTeamNumBg.right
                Text {
                    id: upTeamLapVal
                    width: 125
                    text: qsTr("+23L")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
                anchors.leftMargin: 15
            }

            Rectangle {
                id: upTeamDeltaBg
                y: -177
                width: 160
                height: 60
                color: "#00ff00"
                radius: 10
                border.width: 2
                anchors.left: upTeamLapBg.right
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: upTeamDeltaDisp
                    text: qsTr("+5.34")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
                anchors.leftMargin: 10
            }
        }

        Image {
            id: teamDnLabel
            x: 720
            y: 5
            width: 60
            height: 60
            rotation: 180
            anchors.horizontalCenter: teamUpLabel.horizontalCenter
            anchors.topMargin: 15
            Rectangle {
                id: upTeamNumBg1
                x: 792
                y: -166
                width: 130
                height: 60
                color: "#ffffff"
                radius: 10
                anchors.right: parent.left
                anchors.rightMargin: 30
                rotation: 180
                border.width: 2
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: upTeamNumDisp1
                    text: qsTr("#19")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
            }

            Rectangle {
                id: upTeamLapBg1
                x: 792
                y: -175
                width: 140
                height: 60
                color: "#ffffff"
                radius: 10
                anchors.right: upTeamNumBg1.left
                anchors.rightMargin: 15
                rotation: 180
                border.width: 2
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: upTeamLapVal1
                    text: qsTr("-5L")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
            }

            Rectangle {
                id: upTeamDeltaBg1
                x: 64
                y: -177
                width: 160
                height: 60
                color: "#ff0000"
                radius: 10
                anchors.right: upTeamLapBg1.left
                anchors.rightMargin: 10
                rotation: 180
                border.width: 2
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: upTeamDeltaDisp1
                    text: qsTr("-1.10")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 50
                }
            }
            anchors.top: teamUpLabel.bottom
            fillMode: Image.PreserveAspectFit
            source: "images/triangle.png"
        }

    }






}



/*##^##
Designer {
    D{i:13;anchors_y:"-4"}D{i:14;anchors_x:115}D{i:20;anchors_width:102;anchors_x:731}
D{i:23;anchors_width:102;anchors_x:731}D{i:26;anchors_width:102;anchors_x:731;anchors_y:431}
D{i:29;anchors_width:160;anchors_x:124}D{i:32;anchors_width:160;anchors_x:885}D{i:35;anchors_width:102;anchors_x:731;anchors_y:431}
D{i:40;anchors_x:792}D{i:42;anchors_x:792}D{i:44;anchors_x:64}D{i:39;anchors_x:720;anchors_y:525}
D{i:47;anchors_width:130;anchors_x:792}D{i:49;anchors_width:140;anchors_x:792}D{i:51;anchors_x:64}
D{i:46;anchors_x:720;anchors_y:525}
}
##^##*/
