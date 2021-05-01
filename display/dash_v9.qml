import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0


ApplicationWindow {
    id: root
    color: root.mainBgColor
    visible: true
    width:1280
    height:800
    visibility: "FullScreen"

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


    Rectangle {
        id: rpmSweepMid
        x: -100
        y: 232
        width: 303
        height: 200
        color: root.rpmColor
        visible: true
        z: 0
        rotation: 90
        transformOrigin: Item.TopRight
    }

    onPageChanged: {
        //main
        if (root.page==0){
            timingPage.visible = true
            racePage.visible = false
            messagePage.visible = false
            configPage.visible = false
            //            selection.anchors.horizontalCenter = mainHead.horizontalCenter
            selection.x = timingHead.x-10
            selection.width = timingHead.width+20
            //            const sleep = (milliseconds) => {
            //                return new Promise(resolve => setTimeout(resolve, milliseconds))
            //            }
            timingHead.color = "#0000ff"
            raceHead.color = "#7a755"
            messageHead.color = "#7a755f"
            configHead.color = "#7a755f"
        }
        //time
        if (root.page==1){
            timingPage.visible = false
            racePage.visible = true
            messagePage.visible = false
            configPage.visible = false
            selection.x = raceHead.x-10
            //            selection.anchors.horizontalCenter = timeHead.horizontalCenter
            selection.width = raceHead.width+20
            timingHead.color = "#7a755f"
            raceHead.color = "#0000ff"
            messageHead.color = "#7a755f"
            configHead.color = "#7a755f"
        }
        //tele
        if (root.page==2){
            timingPage.visible = false
            racePage.visible = false
            messagePage.visible = true
            configPage.visible = false
            selection.x = messageHead.x-10
            //            selection.anchors.horizontalCenter = teleHead.horizontalCenter
            selection.width = messageHead.width+20
            timingHead.color = "#7a755f"
            raceHead.color = "#7a755f"
            messageHead.color = "#0000ff"
            configHead.color = "#7a755f"
        }
        //config
        if (root.page==3){
            timingPage.visible = false
            racePage.visible = false
            messagePage.visible = false
            configPage.visible = true
            selection.x = configHead.x-10
            //            selection.anchors.horizontalCenter = configHead.horizontalCenter
            selection.width = configHead.width+20
            timingHead.color = "#7a755f"
            raceHead.color = "#7a755f"
            messageHead.color = "#7a755f"
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
            var sensorDict = con.influxRefresh()
            root.rpm = sensorDict['rpm']    //con.rpm()
            root.speed = sensorDict['speed']    //con.speed()
            tempAirDisp.text = sensorDict['airTemp']    //qsTr(con.airTemp())
            tempEngDisp.text = sensorDict['engTemp']
//            sector1Val = sensorDict['s1Time']
//            sector2Val = sensorDict['s2Time']
//            sector3Val = sensorDict['s3Time']
//            gDot.anchors.verticalCenterOffset = sensorDict['']    //con.accelX()*13.78
//            gDot.anchors.horizontalCenterOffset = sensorDict['']    //con.accelY()*13.78
        }

    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            //teamMsg.text = con.biketest()
            //positionNumber.text = con.raceTimeData('selfPosition')
            //lapNumber.text = con.raceTimeData('selfLaps')
            //lapTimeSelf.text = con.raceTimeData('selfLaptime')
            //positionNumber.text = '2'
            //lapNumber.text = '123'
            //lapTimeSelf.text = '0:49.431'
            //tempAirDisp.text = con.airTemp()
            //sesTDisp.text = sensorDict['']    //Qt.formatDateTime(new Time(), "hh:mm")
            //sesTDisp.text = sensorDict['']    //con.clock()
        }

    }

    //    Behavior on rpm {
    //        NumberAnimation { properties: "rpm"; duration: 1000 }

    //    }



    onRpmChanged: {
        // drive RPM animation
        msgText_pit.text = rpm
        if (rpm<6000) {
            rpmSweepMid.visible = false
            rpmSweepLow.height = rpm*209/6000
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
        }

        if (rpm>6000 && rpm<7000) {
            rpmSweepLow.height = 209
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = (rpm-6000)*9/100
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
        }

        if (rpm>7000 && rpm <11000) {
            rpmSweepLow.height = 209
            rpmSweepHigh.visible = true
            rpmSweepMid.rotation = 90
            rpmSweepHigh.width = (rpm-7000)*697/4000
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false

        }

        if (rpm>11000 && rpm<12000) {
            rpmSweepHigh.width = 697
            rpmSweepOrange.visible = true
            rpmSweepRed.visible = false
            rpmSweepOrange.width = (rpm-11000)*0.175

        }

        if (rpm>12000) {
            rpmSweepHigh.width = 697
            rpmSweepRed.visible = true
            rpmSweepRed.width = (rpm-12000)*.18

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
        x: 0
        y: 230
        width: 90
        height: 209
        color: root.rpmColor
        anchors.left: rpmSweepMid.left
        anchors.leftMargin: 103
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 361
        opacity: 1
        rotation: 0
        transformOrigin: Item.Top
    }


    Rectangle {
        id: rpmSweepHigh
        y: 9
        width: 697
        height: 145
        color: root.rpmColor
        anchors.verticalCenter: rpmSweepOrange.verticalCenter
        anchors.left: parent.left
        anchors.top: rpmSweepOrange.top
        anchors.bottom: rpmSweepOrange.bottom
        anchors.leftMargin: 203
        transformOrigin: Item.Center
    }


    Rectangle {
        id: rpmSweepOrange
        x: 524
        y: 9
        width: 175
        height: 145
        color: "#ff9000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.leftMargin: 900
    }


    Rectangle {
        id: rpmSweepRed
        x: 523
        y: 9
        width: 180
        height: 145
        color: "#ff0000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.leftMargin: 1074
    }

    Image {
        id: baselayer
        source: "images/dashMask_light.png"
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        x: 0
        y: 0
        width: 1280
        height: 800
        opacity: 1
        visible: true
        anchors.verticalCenter: parent.verticalCenter



        Item {
            id: tempGroup
            x: 0
            y: 685
            width: 400
            height: 104

            Rectangle {
                id: tempEngBg
                y: 702
                width: 185
                height: 120
                color: "#00ff00"
                radius: 0
                anchors.left: parent.left
                anchors.verticalCenterOffset: -17
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                border.width: 3
                border.color: root.mainBorderColor

                Text {
                    id: tempEngDisp
                    text: qsTr("175")
                    anchors.horizontalCenterOffset: -10
                    font.bold: true
                    anchors.verticalCenterOffset: -5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 90
                    font.family: "Arial"

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
                    anchors.bottom: parent.bottom
                    font.family: "BN Elements"
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 0
                }
            }

            Rectangle {
                id: tempAirBg
                x: -1
                y: 705
                width: 185
                height: 120
                color: "#00000000"
                radius: 0
                Text {
                    id: tempAirDisp
                    text: qsTr("101")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 90
                    font.family: "Arial"
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
                    anchors.verticalCenterOffset: -5
                    font.bold: true
                }

                Text {
                    id: tempLabel1
                    x: 3
                    y: 7
                    text: qsTr("T AIR")
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 20
                    anchors.bottomMargin: 0
                    font.family: "BN Elements"
                }
                anchors.horizontalCenter: tempEngBg.horizontalCenter
                border.width: 3
                anchors.bottom: tempEngBg.top
                anchors.bottomMargin: 10
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: slipBg
                x: 1
                y: 703
                width: 100
                height: 90
                visible: false
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
                    font.family: "Arial"
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

        Text {
            id: speed
            x: 170
            y: 141
            width: 389
            height: 386
            text: qsTr("88")
            font.italic: false
            font.bold: true
            font.pixelSize: 350
            font.family: "Arial"
            color: root.mainFontColor

            Text {
                id: speedLabel
                x: 152
                y: 314
                text: qsTr("MPH")
                anchors.bottom: parent.bottom
                font.family: "BN Elements"
                font.pixelSize: 36
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.mainFontColor
            }
        }

    }


    MouseArea {
        id: mouseArea
        x: 308
        y: 580
        visible: true
        anchors.fill: parent
        enabled: false
        cursorShape: Qt.BlankCursor
    }

    Item {
        id: pageHead
        x: 570
        y: 252
        width: 710
        height: 40
        visible: true



        Text {
            id: timingHead
            color: "#0000ff"
            text: qsTr("TIMING")
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
            x: timingHead.x-10
            y: timingHead.y
            width: timingHead.width+20
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
            id: head_divider
            x: 0
            y: 36
            width: 702
            height: 4
            color: "#5a5f78"
            anchors.bottom: parent.bottom
            anchors.rightMargin: 8
            anchors.bottomMargin: 0
            border.color: "#7a755f"
            border.width: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: messagePage.top
        }

        Text {
            id: raceHead
            x: 4
            y: 0
            color: "#b0acac"
            text: qsTr("RACE")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 28
            anchors.left: timingHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Text {
            id: messageHead
            x: 0
            y: 4
            color: "#b0acac"
            text: qsTr("MESSAGE")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 28
            anchors.left: raceHead.right
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
            anchors.left: messageHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Item {
            id: timingPage
            x: 0
            y: 36
            width: 710
            height: 512
            visible: true
            anchors.verticalCenter: racePage.verticalCenter
            anchors.horizontalCenter: racePage.horizontalCenter

            Rectangle {
                id: lastLapBg
                width: 660
                height: 200
                color: "#00000000"
                radius: 0
                anchors.top: sessionTimeBg.bottom
                anchors.leftMargin: 0
                anchors.topMargin: 10
                Text {
                    id: lastLapDisp
                    width: 650
                    text: qsTr("0:45.14")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    font.pixelSize: 190
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
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
                border.width: 5
                anchors.left: sessionTimeBg.left
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: lastDeltaBg
                width: 325
                height: 125
                color: "#00ff00"
                radius: 0
                anchors.left: sessionTimeBg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: sessionTimeBg.verticalCenter
                Text {
                    id: lastDeltaDisp
                    text: qsTr("-14.32")
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 100
                    font.family: "Arial"
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
                id: sessionTimeBg
                width: 325
                height: 125
                color: "#00000000"
                radius: 0
                border.width: 4
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 25
                anchors.topMargin: 25
                border.color: root.mainBorderColor
                Text {
                    id: sessionTimeVal
                    width: 130
                    text: qsTr("30:04")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 100
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
                    anchors.verticalCenterOffset: -5
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: sessionTimeLabel
                    text: qsTr("SESSION TIME")
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 7
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: sector1Bg
                x: 10
                width: 215
                height: 125
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
                    font.pixelSize: 80
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
                    anchors.verticalCenterOffset: -5
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: sector1Label
                    text: qsTr("SECTOR 1")
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 0
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
                anchors.topMargin: 10
            }

            Rectangle {
                id: sector3Bg
                x: 474
                y: 290
                width: sector1Bg.width
                height: sector1Bg.height
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
                    font.pixelSize: 80
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
                    anchors.verticalCenterOffset: -5
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: sector3Label
                    text: qsTr("SECTOR 3")
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 0
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: sector2Bg
                x: 242
                y: 290
                width: sector1Bg.width
                height: sector1Bg.height
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
                    font.pixelSize: 80
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
                    anchors.verticalCenterOffset: -5
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: root.mainFontColor
                }

                Text {
                    id: sector2Label
                    text: qsTr("SECTOR 2")
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    font.pixelSize: 20
                    anchors.leftMargin: 7
                    anchors.bottomMargin: 0
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }
            }
        }

        Item {
            id: racePage
            y: 36
            width: 700
            height: 500
            visible: false

            Rectangle {
                id: lapBg
                x: 0
                y: 5
                width: 340
                height: 150
                color: "#00000000"
                radius: 0
                anchors.left: posBg.right
                anchors.verticalCenterOffset: 0
                anchors.leftMargin: 10
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
                    text: qsTr("L837")
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: "Arial"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 140
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.mainFontColor
                }
            }

            Item {
                id: dnGroup
                width: 720
                height: 140
                anchors.left: parent.left
                anchors.top: upGroup.bottom
                anchors.leftMargin: -30
                anchors.topMargin: 30

                Image {
                    id: dnTeamLabel
                    width: 80
                    height: 80
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: 180
                    fillMode: Image.PreserveAspectFit
                    anchors.leftMargin: 10
                    source: "images/triangle_black.png"
                    asynchronous: false
                    mirror: false
                    anchors.left: parent.left
                }

                Rectangle {
                    id: dnTeamNumBg
                    x: 100
                    y: 250
                    width: 160
                    height: 140
                    color: "#00000000"
                    radius: 0
                    border.width: 3
                    anchors.verticalCenter: dnTeamLabel.verticalCenter
                    anchors.left: dnTeamLabel.right
                    anchors.leftMargin: 9
                    border.color: root.mainBorderColor

                    Text {
                        id: dnTeamNumDisp
                        x: 8
                        y: -152
                        height: 90
                        text: qsTr("13")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 90
                        font.family: "Arial"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.mainFontColor
                    }
                }

                Rectangle {
                    id: dnTeamLapBg
                    x: 210
                    y: 250
                    width: 185
                    height: 140
                    color: "#00000000"
                    radius: 0
                    anchors.leftMargin: 10
                    anchors.verticalCenter: dnTeamLabel.verticalCenter
                    anchors.left: dnTeamNumBg.right
                    rotation: 0
                    border.width: 3
                    border.color: root.mainBorderColor

                    Text {
                        id: dnTeamLapVal
                        x: -329
                        y: 72
                        height: 90
                        text: qsTr("-0L")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 90
                        font.family: "Arial"
                        color: root.mainFontColor
                    }
                }

                Rectangle {
                    id: dnTeamDeltaBg
                    x: 340
                    y: 231
                    width: 260
                    height: 140
                    color: "#ff0000"
                    radius: 0
                    anchors.leftMargin: 10
                    anchors.verticalCenter: dnTeamLabel.verticalCenter
                    anchors.left: dnTeamLapBg.right
                    border.width: 3
                    border.color: root.mainBorderColor

                    Text {
                        id: dnTeamDeltaDisp
                        x: -458
                        y: -149
                        height: 90
                        text: qsTr("+15.34")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 90
                        font.family: "Arial"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.mainFontColor
                    }
                }

                Text {
                    id: teamLabelA
                    x: 368
                    y: 435
                    text: qsTr("LAP GAP")
                    anchors.bottom: dnTeamLapBg.top
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 3
                    anchors.horizontalCenter: dnTeamDeltaBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }

                Text {
                    id: teamLabelB
                    x: 180
                    y: 435
                    text: qsTr("LAP DELTA")
                    anchors.bottom: dnTeamLapBg.top
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 3
                    anchors.horizontalCenter: dnTeamLapBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }

                Text {
                    id: teamLabelC
                    x: 96
                    y: 435
                    text: qsTr("TEAM")
                    anchors.bottom: dnTeamNumBg.top
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 3
                    anchors.horizontalCenter: dnTeamNumBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }


            }

            Item {
                id: upGroup
                width: 720
                height: 140
                anchors.left: parent.left
                anchors.top: posBg.bottom
                anchors.leftMargin: -30
                anchors.topMargin: 5

                Image {
                    id: upTeamLabel
                    y: 140
                    width: 80
                    height: 80
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    fillMode: Image.PreserveAspectFit
                    source: "images/triangle_black.png"
                    anchors.leftMargin: 10
                }

                Rectangle {
                    id: upTeamNumBg
                    x: 100
                    y: 145
                    width: 160
                    height: 140
                    color: "#00000000"
                    radius: 0
                    anchors.left: upTeamLabel.right
                    anchors.leftMargin: 9
                    anchors.verticalCenter: upTeamLabel.verticalCenter
                    border.width: 3
                    border.color: root.mainBorderColor

                    Text {
                        id: upTeamNumDisp
                        x: -92
                        y: -3
                        text: qsTr("666")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 90
                        font.family: "Arial"
                        color: root.mainFontColor
                    }
                }

                Rectangle {
                    id: upTeamLapBg
                    x: 210
                    y: 145
                    width: 185
                    height: 140
                    color: "#00000000"
                    radius: 0
                    border.width: 3
                    border.color: root.mainBorderColor
                    anchors.verticalCenter: upTeamLabel.verticalCenter
                    anchors.left: upTeamNumBg.right
                    anchors.verticalCenterOffset: 0
                    anchors.leftMargin: 10

                    Text {
                        id: upTeamLapVal
                        x: -33
                        y: 0
                        width: 186
                        height: 90
                        text: qsTr("+23L")
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "Arial"
                        font.pixelSize: 90
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.mainFontColor
                    }
                }

                Rectangle {
                    id: upTeamDeltaBg
                    x: 370
                    y: 145
                    width: 260
                    height: 140
                    color: "#00ff00"
                    radius: 0
                    border.width: 3
                    border.color: root.mainBorderColor
                    anchors.left: upTeamLapBg.right
                    anchors.verticalCenter: upTeamLabel.verticalCenter
                    anchors.leftMargin: 10

                    Text {
                        id: upTeamDeltaDisp
                        x: -22
                        y: -6
                        height: 90
                        text: qsTr("-5.34")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 90
                        font.family: "Arial"
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.mainFontColor
                    }
                }
            }

            Rectangle {
                id: posBg
                x: 10
                y: 5
                width: 250
                height: 150
                color: "#00000000"
                radius: 0
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 69
                Text {
                    id: posDisp
                    text: qsTr("P11")
                    anchors.verticalCenterOffset: -5
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Arial"
                    font.italic: false
                    font.bold: false
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 140
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



















        }

        Item {
            id: messagePage
            width: 710
            height: 512
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 36

            Rectangle {
                id: msgBox_pit
                x: 175
                y: 166
                width: 350
                height: 175
                visible: true
                color: "#f20000"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: msgText_pit
                    text: qsTr("PIT")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 175
                    anchors.horizontalCenter: parent.horizontalCenter
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
            x: 0
            y: -10
            width: 700
            height: 500
            visible: true
            anchors.top: parent.top
            anchors.topMargin: 40
            mouseEnabled: true
            maximumTouchPoints: 1
            onPressed: {root.page = (root.page != 3) ? root.page+1 : 0}


        }



    }

    Rectangle {
        id: shiftFlasher
        x: -63
        y: 612
        width: 1280
        height: 800
        visible: false
        color: "#ff0000"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }





}









/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}D{i:31;invisible:true}D{i:35;invisible:true}
D{i:34;invisible:true}D{i:33;invisible:true}D{i:54;invisible:true}D{i:55;invisible:true}
D{i:53;invisible:true}D{i:57;invisible:true}D{i:58;invisible:true}D{i:61;invisible:true}
D{i:63;invisible:true}D{i:62;invisible:true}D{i:64;invisible:true}D{i:65;invisible:true}
D{i:66;invisible:true}D{i:56;invisible:true}D{i:68;invisible:true}D{i:67;invisible:true}
}
##^##*/
