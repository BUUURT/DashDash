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

    property color mainFontColor: "black"
    property color mainBorderColor: "black"
    property color mainBgColor: "white"
    property color mainBgColorSub: "#eaeaea"
    property color mainAccentColor: "gray"
    property color mainHighlightColor: "#0000FF"
    property color rpmColor: "#4d6278"
    property int colorMode: 0
    property int rpm: 0
    property int speed: 0
    property int shiftLow: 11000
    property int shiftHigh: 12200
    property var pageSelect: "main"
    property var test: 0
    property int page: 0


    MouseArea {
        anchors.fill: parent
        enabled: false
        //cursorShape: Qt.BlankCursor
    }

    onPageChanged: {
        //main
        if (root.page==0){
            mainPage.visible = true
            timePage.visible = false
            bikePage.visible = false
            configPage.visible = false
            //            selection.anchors.horizontalCenter = mainHead.horizontalCenter
            selection.x = mainHead.x-10
            selection.width = mainHead.width+20
            const sleep = (milliseconds) => {
                return new Promise(resolve => setTimeout(resolve, milliseconds))
            }
            mainHead.color = "#0000ff"
            timeHead.color = "#f0f0f0"
            bikeHead.color = "#f0f0f0"
            configHead.color = "#f0f0f0"
        }
        //time
        if (root.page==1){
            mainPage.visible = false
            timePage.visible = true
            bikePage.visible = false
            configPage.visible = false
            selection.x = timeHead.x-10
            //            selection.anchors.horizontalCenter = timeHead.horizontalCenter
            selection.width = timeHead.width+20
            mainHead.color = "#f0f0f0"
            timeHead.color = "#0000ff"
            bikeHead.color = "#f0f0f0"
            configHead.color = "#f0f0f0"
        }
        //tele
        if (root.page==2){
            mainPage.visible = false
            timePage.visible = false
            bikePage.visible = true
            configPage.visible = false
            selection.x = bikeHead.x-10
            //            selection.anchors.horizontalCenter = teleHead.horizontalCenter
            selection.width = bikeHead.width+20
            mainHead.color = "#f0f0f0"
            timeHead.color = "#f0f0f0"
            bikeHead.color = "#0000ff"
            configHead.color = "#f0f0f0"
        }
        //config
        if (root.page==3){
            mainPage.visible = false
            timePage.visible = false
            bikePage.visible = false
            configPage.visible = true
            selection.x = configHead.x-10
            //            selection.anchors.horizontalCenter = configHead.horizontalCenter
            selection.width = configHead.width+20
            mainHead.color = "#f0f0f0"
            timeHead.color = "#f0f0f0"
            bikeHead.color = "#f0f0f0"
            configHead.color = "#0000ff"
        }
    }

    onColorModeChanged: {
        if (colorMode==0) {

            root.mainFontColor = "black"
            root.mainBgColor = "white"
            root.mainBgColorSub = "eaeaea"
            baselayer.source = "images/dashMask_light.png"
            upTeamLabel.source = "images/triangle_white.png"
            dnTeamLabel.source = "images/triangle_white.png"
        }
        if (colorMode==1) {
            root.mainFontColor = "white"
            root.mainBgColor = "black"
            root.mainBgColorSub = "eaeaea"
            baselayer.source = "images/dashMask_dark.png"
            upTeamLabel.source = "images/triangle_black.png"
            dnTeamLabel.source = "images/triangle_black.png"
        }

    }


    Timer {
        interval: 10
        running: true
        repeat: true
        onTriggered: {
            root.rpm = con.rpm()
            root.speed = con.speed()

            //teamMsg.text = con.biketest()
            //positionNumber.text = con.raceTimeData('selfPosition')
            //lapNumber.text = con.raceTimeData('selfLaps')
            //lapTimeSelf.text = con.raceTimeData('selfLaptime')
            //positionNumber.text = '2'
            //lapNumber.text = '123'
            //lapTimeSelf.text = '0:49.431'
            //tempAirDisp.text = con.airTemp()

        }

    }

    //    Behavior on rpm {
    //        NumberAnimation { properties: "rpm"; duration: 1000 }

    //    }



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
        source: "images/dashMask_light.png"
        x: 0
        y: 0
        width: 1280
        height: 800
        opacity: 1
        visible: true

        Text {
            id: speed
            x: 228
            y: 225
            text: qsTr("61")
            font.italic: false
            font.bold: true
            font.family: "Mont Heavy DEMO"
            font.pixelSize: 300
            color: root.mainFontColor

            Text {
                id: speedLabel
                x: 135
                y: 271
                text: qsTr("MPH")
                font.family: "BN Elements"
                font.pixelSize: 36
                color: root.mainFontColor
            }
        }


        Text {
            id: teamMsg
            x: 8
            y: 538
            width: 545
            height: 101
            text: qsTr("TEAM MSG")
            font.family: "Mont Heavy DEMO"
            font.bold: false
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 80
            color: root.mainFontColor
        }

        Item {
            id: tempGroup
            x: 0
            y: 685
            width: 400
            height: 104

            Rectangle {
                id: tempEngBg
                y: 702
                width: 130
                height: 90
                color: "#00ff00"
                radius: 0
                anchors.left: parent.left
                anchors.leftMargin: 25
                anchors.verticalCenter: parent.verticalCenter
                border.width: 3
                border.color: root.mainBorderColor

                Text {
                    id: tempEngDisp
                    text: qsTr("175")
                    anchors.horizontalCenterOffset: -10
                    font.bold: true
                    font.family: "Mont Heavy DEMO"
                    anchors.verticalCenterOffset: -10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 60

                    Text {
                        id: tempDot
                        y: 35
                        color: "#000000"
                        text: qsTr("°")
                        anchors.left: parent.right
                        anchors.leftMargin: 0
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 20
                        anchors.verticalCenterOffset: -12
                        font.family: "Arial"
                        rotation: 0

                        Text {
                            id: tempF
                            x: 95
                            y: 21
                            text: qsTr("F")
                            anchors.leftMargin: 0
                            anchors.verticalCenter: tempDot.verticalCenter
                            font.pixelSize: 20
                            anchors.left: parent.right
                            anchors.verticalCenterOffset: 0
                            font.family: "BN Elements"
                            rotation: 0
                        }
                    }

                }

                Text {
                    id: tempLabel
                    x: 3
                    y: 7
                    text: qsTr("T ENG")
                    font.family: "BN Elements"
                    font.pixelSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 30
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id: tempAirBg
                x: -1
                y: 705
                width: 130
                height: 90
                radius: 0
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: tempAirDisp
                    text: qsTr("101")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 60
                    anchors.horizontalCenterOffset: -10
                    Text {
                        id: tempDot1
                        y: 35
                        text: qsTr("°")
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 20
                        Text {
                            id: tempF1
                            x: 95
                            y: 21
                            text: qsTr("F")
                            anchors.leftMargin: 0
                            anchors.verticalCenter: tempDot1.verticalCenter
                            font.pixelSize: 20
                            anchors.left: parent.right
                            anchors.verticalCenterOffset: 0
                            font.family: "BN Elements"
                            rotation: 0
                        }
                        anchors.left: parent.right
                        anchors.verticalCenterOffset: -12
                        font.family: "Arial"
                        font.bold: true
                        rotation: 0
                    }
                    anchors.verticalCenterOffset: -10
                    font.bold: true
                    font.family: "Mont Heavy DEMO"
                }

                Text {
                    id: tempLabel1
                    x: 3
                    y: 7
                    text: qsTr("T AIR")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30
                    anchors.verticalCenterOffset: 30
                    font.family: "BN Elements"
                }
                anchors.left: tempEngBg.right
                border.width: 3
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: slipBg
                x: 1
                y: 703
                width: 100
                height: 90
                color: "#8ca6ff"
                radius: 0
                border.width: 3
                border.color: root.mainBorderColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: tempAirBg.right
                anchors.leftMargin: 15
                Text {
                    id: slipVal
                    text: qsTr("5")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 60
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenterOffset: -10
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: slipLael
                    x: 3
                    y: 7
                    text: qsTr("TC")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30
                    anchors.verticalCenterOffset: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }
        }

        Rectangle {
            id: leftEdgeBugfix
            width: 20
            height: parent.height
            color: root.mainBgColor
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Rectangle {
            id: raceClockBg
            width: 140
            height: 75
            color: "#00000000"
            radius: 0
            border.color: root.mainBorderColor
            anchors.top: parent.top
            anchors.topMargin: 3
            Text {
                id: sesTDisp
                text: qsTr("5:45")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 65
                anchors.verticalCenterOffset: -7
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.mainFontColor

            }

            Text {
                id: sesTlabel
                text: qsTr("RACE CLOCK")
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.bottom
                anchors.topMargin: -17
                font.pixelSize: 15
                font.family: "BN Elements"
                color: root.mainFontColor
            }
            MultiPointTouchArea {
                anchors.fill: parent
                onPressed: {root.colorMode = (root.colorMode == 0) ? 1 : 0}}

            anchors.leftMargin: 3
            anchors.left: parent.left
            border.width: 3


        }

    }













    Item {
        id: pageHead
        x: 570
        y: 252
        width: 710
        height: 40
        visible: true



        Text {
            id: mainHead
            color: "#0000ff"
            text: qsTr("MAIN")
            styleColor: "#0000ff"
            anchors.verticalCenterOffset: 3
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            font.family: "BN Elements"
            font.pixelSize: 28
        }
        Rectangle {
            id: selection
            x: mainHead.x-10
            y: mainHead.y
            width: mainHead.width+20
            height: 30
            color: "#00000000"
            anchors.verticalCenter: parent.verticalCenter
            visible: true
            //            anchors.horizontalCenter: mainHead.horizontalCenter
            border.width: 4
            border.color: root.mainHighlightColor
            Behavior on x { NumberAnimation{duration:250}}
            Behavior on width { NumberAnimation{duration:250}}
        }

        Rectangle {
            id: rectangle
            x: 0
            y: 46
            width: 710
            height: 4
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            border.color: "#f2f2f2"
            border.width: 2
        }

        Text {
            id: timeHead
            x: 4
            y: 0
            color: "#b0acac"
            text: qsTr("TIMING")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 28
            anchors.left: mainHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Text {
            id: bikeHead
            x: 0
            y: 4
            color: "#b0acac"
            text: qsTr("BIKE")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 28
            anchors.left: timeHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Text {
            id: configHead
            x: 5
            y: -3
            color: "#b0acac"
            text: qsTr("CONFIG")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 28
            anchors.left: bikeHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Item {
            id: mainPage
            x: 0
            y: 36
            width: 710
            height: 512
            visible: true

            Rectangle {
                id: posBg
                width: 215
                height: 110
                color: "#00000000"
                radius: 0
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                Text {
                    id: posDisp
                    text: qsTr("P11")
                    anchors.verticalCenterOffset: -5
                    horizontalAlignment: Text.AlignHCenter
                    font.italic: false
                    font.family: "Mont Heavy DEMO"
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 90
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: posLabel
                    text: qsTr("POSITION")
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    font.pixelSize: 15
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                border.width: 4
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: lapBg
                x: 315
                y: 101
                width: 215
                height: 110
                color: "#00000000"
                radius: 0
                anchors.left: posBg.right
                anchors.leftMargin: 20
                anchors.verticalCenter: posBg.verticalCenter

                Text {
                    id: lapLabel
                    text: qsTr("LAP")
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    font.pixelSize: 15
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                border.width: 4
                border.color: root.mainBorderColor
                Text {
                    id: lapDisp
                    width: 130
                    text: qsTr("L114")
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: "Mont Heavy DEMO"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 90
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: lastLapBg
                x: 150
                y: 241
                width: 450
                height: 150
                color: "#00000000"
                radius: 0
                anchors.top: posBg.bottom
                anchors.topMargin: 10
                Text {
                    id: lastLapDisp
                    width: 440
                    text: qsTr("0:45.14")
                    font.bold: true
                    font.family: "Mont Heavy DEMO"
                    anchors.verticalCenterOffset: -10
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 130
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: lastLapLabel
                    text: qsTr("LAST LAP")
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    font.family: "BN Elements"
                    anchors.bottomMargin: 0
                    color: root.mainFontColor
                }
                anchors.leftMargin: 0
                anchors.left: posBg.left
                border.width: 5
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: lastDeltaBg
                width: 230
                height: 150
                color: "#00ff00"
                radius: 0
                anchors.left: lastLapBg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: lastLapBg.verticalCenter
                Text {
                    id: lastDeltaDisp
                    text: qsTr("+4.32")
                    font.bold: true
                    font.family: "Mont Heavy DEMO"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: lastDeltaLabel
                    height: 23
                    text: qsTr("DELTA")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 7
                    font.pixelSize: 20
                    font.family: "BN Elements"
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }
                border.width: 4
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: currentLapBg
                x: 317
                width: 250
                height: 85
                color: "#00000000"
                radius: 0
                anchors.top: lastDeltaBg.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: lastDeltaBg.horizontalCenter
                anchors.leftMargin: 10
                Text {
                    id: currentLapVal
                    width: 130
                    text: qsTr("0:32.54")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 65
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenterOffset: -5
                    font.family: "Mont Heavy DEMO"
                    font.bold: false
                    color: root.mainFontColor
                }

                Text {
                    id: currentLapLabel
                    text: qsTr("CURRENT LAP")
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 7
                    font.pixelSize: 15
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                anchors.left: lapBg.right
                border.width: 4
                border.color: root.mainBorderColor
            }


            Rectangle {
                id: sessionTimeBg
                x: 470
                y: 385
                width: 230
                height: 110
                color: "#00000000"
                radius: 0
                border.width: 4
                border.color: root.mainBorderColor
                anchors.left: lapBg.right
                anchors.top: lapBg.top
                anchors.horizontalCenterOffset: 0
                anchors.leftMargin: 10
                anchors.horizontalCenter: lastDeltaBg.horizontalCenter
                Text {
                    id: sessionTimeVal
                    width: 130
                    text: qsTr("30:04")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 90
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenterOffset: -5
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: sessionTimeLabel
                    text: qsTr("SESSION TIME")
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 15
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 7
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                anchors.topMargin: 0
            }
        }

        Item {
            id: timePage
            y: 36
            width: 710
            height: 512
            visible: true

            Text {
                id: upTeamDeltaDisp
                x: 318
                y: 379
                text: qsTr("+5.34")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 50
                color: root.mainFontColor
            }

            Rectangle {
                id: upTeamDeltaBg
                x: 310
                y: 385
                width: 150
                height: 50
                color: "#00ff00"
                radius: 0
                border.width: 3
                border.color: root.mainBorderColor
                anchors.left: upTeamLapBg.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
            }

            Text {
                id: upTeamLapVal
                x: 177
                y: 385
                width: 125
                height: 50
                text: qsTr("+23L")
                font.family: "Mont Heavy DEMO"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 50
                color: root.mainFontColor
            }

            Rectangle {
                id: upTeamLapBg
                x: 180
                y: 385
                width: 120
                height: 50
                color: "#00000000"
                radius: 0
                border.width: 3
                border.color: root.mainBorderColor
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: upTeamNumBg.right
                anchors.leftMargin: 10
            }

            Text {
                id: upTeamNumDisp
                x: 78
                y: 382
                text: qsTr("666")
                font.family: "Mont Heavy DEMO"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 50
                color: root.mainFontColor
            }

            Rectangle {
                id: upTeamNumBg
                x: 70
                y: 385
                width: 100
                height: 50
                color: "#00000000"
                radius: 0
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                border.width: 3
                border.color: root.mainBorderColor
            }

            Image {
                id: upTeamLabel
                x: 10
                y: 385
                width: 50
                height: 50
                anchors.top: lastLapBg.bottom
                anchors.topMargin: 105
                anchors.left: lastLapBg.right
                anchors.leftMargin: -450
                fillMode: Image.PreserveAspectFit
                source: "images/triangle_black.png"
            }

            Text {
                id: teamLabelC
                x: 91
                y: 435
                text: qsTr("TEAM")
                anchors.top: parent.top
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "BN Elements"
                anchors.topMargin: -20
                color: root.mainFontColor
            }

            Text {
                id: teamLabelB
                x: 180
                y: 435
                text: qsTr("LAP DELTA")
                anchors.verticalCenter: teamLabelA.verticalCenter
                anchors.left: dnTeamLapBg.left
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                anchors.leftMargin: 0
                font.family: "BN Elements"
                color: root.mainFontColor
            }

            Text {
                id: teamLabelA
                x: 338
                y: 435
                text: qsTr("LAP GAP")
                anchors.top: parent.top
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: dnTeamDeltaBg.horizontalCenter
                anchors.topMargin: -20
                font.family: "BN Elements"
                color: root.mainFontColor
            }

            Text {
                id: dnTeamDeltaDisp
                x: 318
                y: 449
                text: qsTr("+5.34")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 50
                color: root.mainFontColor
            }

            Rectangle {
                id: dnTeamDeltaBg
                x: 310
                y: 455
                width: 150
                height: 50
                color: "#ff0000"
                radius: 0
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: dnTeamLapBg.right
                border.width: 3
                border.color: root.mainBorderColor
            }

            Text {
                id: dnTeamLapVal
                x: 204
                y: 452
                text: qsTr("-0L")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 50
                font.family: "Mont Heavy DEMO"
                color: root.mainFontColor
            }

            Rectangle {
                id: dnTeamLapBg
                x: 180
                y: 455
                width: 120
                height: 50
                color: "#00000000"
                radius: 0
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: dnTeamNumBg.right
                border.width: 3
                border.color: root.mainBorderColor
            }

            Text {
                id: dnTeamNumDisp
                x: 92
                y: 452
                text: qsTr("13")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 50
                font.family: "Mont Heavy DEMO"
                color: root.mainFontColor
            }

            Rectangle {
                id: dnTeamNumBg
                x: 70
                y: 455
                width: 100
                height: 50
                color: "#00000000"
                radius: 0
                anchors.top: upTeamLabel.bottom
                anchors.topMargin: 20
                anchors.leftMargin: 10
                anchors.left: upTeamLabel.right
                border.width: 3
                border.color: root.mainBorderColor
            }

            Image {
                id: dnTeamLabel
                x: 10
                y: 450
                width: 50
                height: 50
                rotation: 180
                anchors.horizontalCenter: upTeamLabel.horizontalCenter
                anchors.top: upTeamLabel.bottom
                fillMode: Image.PreserveAspectFit
                anchors.topMargin: 15
                anchors.leftMargin: -450
                source: "images/triangle_black.png"
                anchors.left: lastLapBg.right
            }

            Rectangle {
                id: sector2Bg
                x: 162
                y: 290
                width: 145
                height: 85
                visible: true
                color: "#00000000"
                radius: 0
                border.width: 4
                border.color: root.mainBorderColor
                anchors.verticalCenter: sector1Bg.verticalCenter
                anchors.left: sector1Bg.right
                anchors.leftMargin: 7
                Text {
                    id: sector2Val
                    width: 130
                    text: qsTr("12.89")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 50
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenterOffset: -5
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: sector2Label
                    text: qsTr("SECTOR 2")
                    anchors.bottom: parent.bottom
                    font.pixelSize: 15
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: sector3Bg
                x: 314
                y: 290
                width: 145
                height: 85
                visible: true
                color: "#00000000"
                radius: 0
                border.width: 4
                border.color: root.mainBorderColor
                anchors.verticalCenter: sector2Bg.verticalCenter
                anchors.left: sector2Bg.right
                anchors.leftMargin: 7
                Text {
                    id: sector3Val
                    width: 130
                    text: qsTr("19.71")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 50
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenterOffset: -5
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: sector3Label
                    text: qsTr("SECTOR 3")
                    anchors.bottom: parent.bottom
                    font.pixelSize: 15
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: sector1Bg
                x: 10
                y: 290
                width: 145
                height: 85
                visible: true
                color: "#00000000"
                radius: 0
                border.width: 4
                border.color: root.mainBorderColor
                anchors.left: lastLapBg.left
                anchors.top: lastLapBg.bottom
                anchors.leftMargin: 0
                Text {
                    id: sector1Val
                    width: 130
                    text: qsTr("20.45")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 50
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenterOffset: -5
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: sector1Label
                    text: qsTr("SECTOR 1")
                    anchors.bottom: parent.bottom
                    font.pixelSize: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 0
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                anchors.topMargin: 10
            }

            Rectangle {
                id: bestLapBg
                x: 470
                y: 10
                width: 230
                height: 110
                color: "#00000000"
                radius: 0
                anchors.leftMargin: 10
                anchors.verticalCenter: posBg.verticalCenter
                Text {
                    id: bestLapVal
                    width: 130
                    text: qsTr("0:42.61")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 65
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: "Mont Heavy DEMO"
                    color: root.mainFontColor
                }

                Text {
                    id: bestLapLabel
                    text: qsTr("BEST LAP")
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 7
                    font.pixelSize: 15
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                anchors.left: lapBg.right
                border.width: 4
                border.color: root.mainBorderColor
            }


















        }

        Item {
            id: bikePage
            width: 710
            height: 512
            visible: true
            anchors.top: parent.top
            anchors.topMargin: 36


            Rectangle {
                id: leanDisp
                x: 500
                y: 33
                width: 15
                height: 275
                visible: true
                color: "#00ff00"
                border.width: 2
                rotation: 0
                transformOrigin: Item.Bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                id: teleBg
                x: -250
                y: -161
                width: 700
                height: 450
                visible: true
                anchors.verticalCenter: parent.verticalCenter
                source: "images/tele_light.png"
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit

                Rectangle {
                    id: gboundary
                    x: 175
                    y: 98
                    width: 350
                    height: 350
                    visible: true
                    color: "#00000000"
                    radius: 175
                    border.color: "#00000000"

                    Rectangle {
                        id: gDot
                        x: 167
                        y: 167
                        width: 25
                        height: 25
                        visible: true
                        color: "#00ff00"
                        radius: 12
                        border.width: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenterOffset: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

        }

        Item {
            id: configPage
            width: 200
            height: 200
            visible: true
        }


        MultiPointTouchArea {
            id: pageR
            x: 75
            y: 0
            width: 640
            height: 550
            mouseEnabled: true
            maximumTouchPoints: 1
            onPressed: {root.page = (root.page != 3) ? root.page+1 : 0}


        }
    }



}









/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:57;invisible:true}D{i:87;invisible:true}D{i:92;invisible:true}
}
##^##*/
