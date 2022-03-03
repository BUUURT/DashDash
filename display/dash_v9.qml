import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0


ApplicationWindow {
    id: root
    visible: true
    color: "#d4d1d1"
    width:1280
    height:800
    //visibility: "FullScreen"

    property color mainFontColor: "black"
    property color mainBorderColor: "black"
    property color mainBgColor: "white"
    property color mainBgColorSub: "#eaeaea" //#b0acac //unused
    property color mainAccentColor: "gray" //unused
    property color pageHighlightColor: "#0000FF"
    property color pageBaseColor: "gray"
    property color pageBorderColor: "#7a755f"
    property color rpmColor: "#3f465e"

    property bool darkMode: false
    property int rpm: 0
    property int speed: 0
    property int engTemp: 0
    property int shiftLight: 12000
    property var pageSelect: "main" //unused
    property int page: 2
    property var units: 'standard'

    property bool msgTemp: false
    property bool msgPit: false
    property bool msgCustom: false

    SequentialAnimation {
        running: true
        NumberAnimation { target: root; property: "rpm"; to: 13000; duration: 1000 }
        NumberAnimation { target: root; property: "rpm"; to: 0; duration: 1000 }
    }

    onMsgTempChanged: {if (root.msgTemp==true){root.page = 2}}
    onMsgPitChanged: {if (root.msgPit==true) root.page = 2}
    onMsgCustomChanged: {if (root.msgCustom == true) root.page = 2}

    Rectangle {
        id: rpmSweepMid
        x: -100
        y: 232
        width: 303
        height: 200
        visible: false
        color: root.rpmColor
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
            timingHead.color = root.pageHighlightColor
            raceHead.color = root.pageBaseColor
            messageHead.color = root.pageBaseColor
            configHead.color = root.pageBaseColor
            pageR.visible = true
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
            timingHead.color = root.pageBaseColor
            raceHead.color = root.pageHighlightColor
            messageHead.color = root.pageBaseColor
            configHead.color = root.pageBaseColor
            pageR.visible = true
        }
        //msg
        if (root.page==2){
            timingPage.visible = false
            racePage.visible = false
            messagePage.visible = true
            configPage.visible = false
            selection.x = messageHead.x-10
            //            selection.anchors.horizontalCenter = teleHead.horizontalCenter
            selection.width = messageHead.width+20
            timingHead.color = root.pageBaseColor
            raceHead.color = root.pageBaseColor
            messageHead.color = root.pageHighlightColor
            configHead.color = root.pageBaseColor
            pageR.visible = false
        }
        //config
        if (root.page==9){
            timingPage.visible = false
            racePage.visible = false
            messagePage.visible = false
            configPage.visible = true
            selection.x = configHead.x-10
            //            selection.anchors.horizontalCenter = configHead.horizontalCenter
            selection.width = configHead.width+20
            timingHead.color = root.pageBaseColor
            raceHead.color = root.pageBaseColor
            messageHead.color = root.pageBaseColor
            configHead.color = root.pageHighlightColor
            pageR.visible = false
        }
    }
    Timer {
        id: pageLooper
        interval: 3000
        running: false
        repeat: true
        onTriggered: {root.page = (root.page != 1) ? root.page+1 : 0 ; console.log(pageLooper.running)}
    }

    onDarkModeChanged: {
        if (darkMode==false) {
            root.color = "#d4d1d1"
            root.mainFontColor = "black"
            root.mainBgColor = "white"
            root.mainBgColorSub = "eaeaea"
            root.mainBorderColor = "black"
            root.rpmColor = "#3f465e"
            root.pageBorderColor = "#7a755f"
            baselayer.source = "images/dashMask_light.png"
            //            upTeamLabel.source = "images/triangle_white.png"
            //            dnTeamLabel.source = "images/triangle_white.png"
        }
        if (darkMode==true) {
            root.color = "#2b2828"
            root.mainFontColor = "white"
            root.mainBgColor = "black"
            root.mainBgColorSub = "eaeaea"
            root.mainBorderColor = "#333333"
            root.rpmColor = "#f2f5ff"
            root.pageBorderColor = "#333333"
            //root.mainBorderColor = "white"
            baselayer.source = "images/dashMask_dark.png"
            //            upTeamLabel.source = "images/triangle_black.png"
            //            dnTeamLabel.source = "images/triangle_black.png"
        }

    }



    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            var sensorDict = con.sensorRefresh()
            root.rpm = parseInt(sensorDict['rpm'])    //con.rpm()
            root.speed = parseInt(sensorDict['speed'])    //con.speed(w)
            tempAirDisp.text = String(sensorDict['airTemp'])    //qsTr(con.airTemp())
            tempEngDisp.text = String(sensorDict['engTemp'])
            //            root.engTemp = parseInt(sensorDict['engTemp'])
            //            sector1Val = sensorDict['s1Time']
            //            sector2Val = sensorDict['s2Time']
            //            sector3Val = sensorDict['s3Time']
            //            gDot.anchors.verticalCenterOffset = sensorDict['']    //con.accelX()*13.78
            //            gDot.anchors.horizontalCenterOffset = sensorDict['']    //con.accelY()*13.78
            //                    # speed,<class 'int'>
            //                    # rpm,<class 'int'>
            //                    # engTemp,<class 'float'>
            //                    # airTemp,<class 'float'>
            //                    # gps_lat,<class 'bool'>
            //                    # gps_long,<class 'bool'>
            //                    # rotationX,<class 'float'>
            //                    # rotationY,<class 'float'>
            //                    # rotationZ,<class 'float'>
            //                    # accelX,<class 'float'>
            //                    # accelY,<class 'float'>
            //                    # accelZ,<class 'float'>
            //                    # laptime,<class 'int'>
            //                    # s1Time,<class 'int'>
            //                    # s2Time,<class 'int'>
            //                    # s3Time,<class 'int'>
        }

    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            sessionTimeVal.text = con.sessionTime()
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

    onRpmChanged: {
        // drive RPM animation

        if (rpm<6000) {
            rpmSweepLow.height = rpm*0.03483
            rpmSweepMid.visible = false
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
            shiftFlash.running = false
        }

        if (rpm>6000 && rpm<7000) {
            rpmSweepLow.height = 209
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = (rpm-6000)*.09
            rpmSweepHigh.visible = false
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
            shiftFlash.running = false
        }

        if (rpm>7000 && rpm <11000) {
            rpmSweepLow.height = 209
            rpmSweepHigh.visible = true
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = 90
            rpmSweepHigh.width = (rpm-7000)*0.17425
            rpmSweepOrange.visible = false
            rpmSweepRed.visible = false
            shiftFlash.running = false
        }

        if (rpm>11000 && rpm<12000) {
            rpmSweepLow.height = 209
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = 90
            rpmSweepHigh.width = 697
            rpmSweepOrange.visible = true
            rpmSweepOrange.width = (rpm-11000)*0.175
            rpmSweepRed.visible = false
            shiftFlash.running = false
            shiftFlasher.visible = false

        }

        if (rpm>12000) {
            rpmSweepLow.height = 209
            rpmSweepMid.visible = true
            rpmSweepMid.rotation = 90
            rpmSweepHigh.visible = true
            rpmSweepHigh.visible = true
            rpmSweepHigh.width = 697
            rpmSweepOrange.visible = true
            rpmSweepOrange.width = 175
            rpmSweepRed.visible = true
            rpmSweepRed.width = (rpm-12000)*.18
            shiftFlash.running = true

        }
    }
    Timer {
        id: shiftFlash
        interval: 80
        running: false
        repeat: true
        onTriggered: { shiftFlasher.visible = !shiftFlasher.visible}

    }

    onEngTempChanged: {
        tempEngDisp.text = root.engTemp
        if (root.engTemp < 70) {tempEngBg.color = '#0000ff'}
        if (root.engTemp > 70 && root.engTemp < 115) {tempEngBg.color = Qt.rgba(0, (root.engTemp-70)/45, 1, 0.9)}
        if (root.engTemp > 115 && root.engTemp < 160) {tempEngBg.color = Qt.rgba(0, 1, 1-(root.engTemp-115)/45, 1)}
        if (root.engTemp > 180 && root.engTemp < 200) {tempEngBg.color = Qt.rgba((root.engTemp-180)/20, 1, 0, 1)}
        if (root.engTemp > 200) {tempEngBg.color = Qt.rgba(1,1-(root.engTemp-200)/20, 0, 1)}
    }

    onSpeedChanged: {
        speed.text = root.speed
    }

    Rectangle {
        id: rpmSweepLow
        x: 0
        y: 230
        width: 90
        height: 1
        anchors.left: rpmSweepMid.left
        anchors.leftMargin: 103
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 361
        opacity: 1
        visible: true
        color: root.rpmColor
        rotation: 0
        transformOrigin: Item.Top
    }

    Rectangle {
        id: rpmSweepHigh
        y: 9
        width: 697
        height: 145
        visible: false
        color: root.rpmColor//"#3f465e"
        anchors.left: parent.left
        anchors.top: rpmSweepOrange.top
        anchors.bottom: rpmSweepOrange.bottom
        anchors.leftMargin: 203
        transformOrigin: Item.Center
    }


    Rectangle {
        id: rpmSweepOrange
        x: 524
        width: 175
        height: 145
        visible: false
        color: "#ff9000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.leftMargin: 900
    }


    Rectangle {
        id: rpmSweepRed
        x: 523
        width: 180
        height: 145
        visible: false
        color: "#ff0000"
        transformOrigin: Item.Center
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 0
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
                color: "#00000000"
                radius: 0
                anchors.left: parent.left
                anchors.verticalCenterOffset: -17
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                border.width: 3
                border.color: root.mainBorderColor

                Text {
                    id: tempEngDisp
                    text: qsTr("-")
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
                border.color: root.mainBorderColor
                PropertyAnimation {
                    id: propertyAnimation
                }

                Text {
                    id: tempAirDisp
                    text: qsTr("-")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 90
                    font.family: "Arial"
                    color: root.mainFontColor
                    anchors.horizontalCenterOffset: -10
                    Text {
                        id: tempDot1
                        y: 35
                        text: qsTr("°")
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 20
                        color: root.mainFontColor
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
                            color: root.mainFontColor
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
                    color: root.mainFontColor
                }

                anchors.horizontalCenter: tempEngBg.horizontalCenter
                border.width: 3
                anchors.bottom: tempEngBg.top
                anchors.bottomMargin: 10
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
            text: qsTr("0")
            font.italic: false
            font.bold: true
            font.pixelSize: 350
            horizontalAlignment: Text.AlignHCenter
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
        visible: true
        anchors.fill: parent
        enabled: false
        //        cursorShape: Qt.BlankCursor

        Dial {
            id: dial
            value:0
            x: 286
            y: 546
            width: 75
            height: 75
            visible: false
            stepSize: 1
            to: 13000
            onValueChanged: {root.rpm = value}

            Text {
                id: text1
                x: 26
                y: 30
                text: qsTr("RPM")
                font.pixelSize: 12
            }
        }

        Slider {
            id: slider
            x: 273
            y: 636
            visible: false
            value: 0
            to: 300
            onValueChanged: {root.engTemp = value}
        }

        Slider {
            id: slider1
            x: 273
            y: 704
            visible: false
            value: 0
            to: 100
            onValueChanged: {root.speed = value}
        }

        Button {
            id: settingsIcon
            x: 8
            width: 40
            height: 40
            opacity: 1
            text: qsTr("")
            anchors.top: parent.top
            display: AbstractButton.IconOnly
            autoRepeat: true
            checkable: false
            //display: AbstractButton.IconOnly
            highlighted: false
            anchors.topMargin: 8
            Image {
                source: "gear.png"
                width: parent.width
                height:parent.height
            }
            background: Rectangle {
                color: parent.pressed ? "gray" : "transparent"
                radius: 20
            }
            onPressed: {
                root.page = 9


            }
        }
    }
    Item {
        id: pageHead
        x: 570
        y: 205
        width: 710
        height: 40
        visible: true



        Rectangle {
            id: head_divider
            x: 0
            y: 36
            width: 701
            height: 4
            color: root.pageBorderColor
            anchors.bottom: parent.bottom
            anchors.leftMargin: -1
            anchors.topMargin: 0
            anchors.rightMargin: 9
            anchors.bottomMargin: 0
            border.color: root.pageBorderColor
            border.width: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: messagePage.top
        }

        Text {
            id: timingHead
            color: root.pageBaseColor
            text: qsTr("TIMING")
            styleColor: "#0000ff"
            anchors.verticalCenterOffset: 3
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            font.family: "BN Elements"
            font.pixelSize: 32
            property bool current : true

            onCurrentChanged: {
                timingHead.color = root.pageHighlightcolor
            }
        }
        Rectangle {
            id: selection
            x: messageHead.x-10
            y: messageHead.y
            width: messageHead.width+20
            height: 42
            color: "#00000000"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -1
            visible: true
            //            anchors.horizontalCenter: mainHead.horizontalCenter
            border.width: 4
            border.color: root.pageHighlightColor
            Behavior on x { NumberAnimation{duration:250}}
            Behavior on width { NumberAnimation{duration:250}}
        }


        Text {
            id: raceHead
            x: 4
            y: 0
            color: root.pageBaseColor
            text: qsTr("RACE")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 32
            anchors.left: timingHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Text {
            id: messageHead
            x: 0
            y: 4
            color: root.pageHighlightColor
            text: qsTr("MESSAGE")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 32
            anchors.left: raceHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Text {
            id: configHead
            x: 5
            y: -3
            color: root.pageBaseColor
            text: qsTr("CONFIG")
            styleColor: "#0000ff"
            anchors.leftMargin: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 32
            anchors.left: messageHead.right
            anchors.verticalCenterOffset: 3
            font.family: "BN Elements"
        }

        Item {
            id: timingPage
            width: 680
            height: 540
            visible: true
            anchors.left: parent.left
            anchors.top: parent.bottom
            anchors.topMargin: 0
            anchors.leftMargin: 0

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
                    text: qsTr("--")
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
                border.width: 4
                anchors.left: sessionTimeBg.left
                border.color: root.mainBorderColor
            }

            Rectangle {
                id: lastDeltaBg
                width: 325
                height: 150
                visible: true
                color: "#00000000"
                radius: 0
                anchors.left: sessionTimeBg.right
                anchors.leftMargin: 10
                anchors.verticalCenter: sessionTimeBg.verticalCenter
                Text {
                    id: lastDeltaDisp
                    text: qsTr("--")
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 110
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
                height: 150
                color: "#00000000"
                radius: 0
                border.width: 4
                border.color: root.mainBorderColor
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20
                Text {
                    id: sessionTimeVal
                    width: 130
                    text: qsTr("--")
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 110
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
                id: lapBg
                x: 334
                y: 14
                width: 350
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
                    text: qsTr("-")
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: false
                    font.family: "Arial"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 140
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.mainFontColor
                }
            }

            Rectangle {
                id: posBg
                x: 74
                y: 14
                width: 300
                height: 150
                color: "#00000000"
                radius: 0
                anchors.top: lastLapBg.bottom
                anchors.topMargin: 10
                anchors.left: lastLapBg.left
                anchors.leftMargin: 0
                Text {
                    id: posDisp
                    text: qsTr("-")
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
            id: racePage
            width: 680
            height: 540
            visible: false
            anchors.left: parent.left
            anchors.top: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0

            Item {
                id: dnGroup
                width: 660
                height: 150
                anchors.left: parent.left
                anchors.top: sectorGroup.bottom
                anchors.leftMargin: 20
                anchors.topMargin: 10

                Rectangle {
                    id: dnTeamNumBg
                    y: 250
                    width: 160
                    height: parent.height
                    color: "#00000000"
                    radius: 0
                    border.width: 4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
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
                    width: 200
                    height: parent.height
                    color: "#00000000"
                    radius: 0
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: dnTeamNumBg.right
                    rotation: 0
                    border.width: 4
                    border.color: root.mainBorderColor

                    Text {
                        id: dnTeamLapVal
                        x: -329
                        y: 72
                        height: 90
                        text: qsTr("0")
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
                    width: 280
                    height: parent.height
                    color: "#ff0000"
                    radius: 0
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: dnTeamLapBg.right
                    border.width: 4
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
                    anchors.bottom: dnTeamLapBg.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: dnTeamDeltaBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }

                Text {
                    id: teamLabelB
                    x: 180
                    y: 435
                    text: qsTr("LAP DELTA")
                    anchors.bottom: dnTeamLapBg.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: dnTeamLapBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }

                Text {
                    id: teamLabelC
                    x: 96
                    y: 435
                    text: qsTr("TEAM")
                    anchors.bottom: dnTeamNumBg.bottom
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottomMargin: 0
                    anchors.horizontalCenter: dnTeamNumBg.horizontalCenter
                    font.family: "BN Elements"
                    color: root.mainFontColor
                }


            }

            Item {
                id: upGroup
                width: 660
                height: 150
                anchors.left: sectorGroup.left
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.leftMargin: 0

                Rectangle {
                    id: upTeamNumBg
                    y: 145
                    width: 160
                    height: parent.height
                    color: "#00000000"
                    radius: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 4
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

                    Text {
                        id: teamLabelC1
                        x: 96
                        y: 435
                        color: root.mainFontColor
                        text: qsTr("TEAM")
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.bottomMargin: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "BN Elements"
                    }
                }

                Rectangle {
                    id: upTeamLapBg
                    x: 210
                    y: 145
                    width: 200
                    height: parent.height
                    color: "#00000000"
                    radius: 0
                    border.width: 4
                    border.color: root.mainBorderColor
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: upTeamNumBg.right
                    anchors.verticalCenterOffset: 0
                    anchors.leftMargin: 10

                    Text {
                        id: upTeamLapVal
                        x: -33
                        y: 0
                        width: 186
                        height: 90
                        text: qsTr("23")
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "Arial"
                        font.pixelSize: 90
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.mainFontColor
                    }

                    Text {
                        id: teamLabelB1
                        x: 10
                        y: 435
                        color: root.mainFontColor
                        text: qsTr("LAP DELTA")
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.bottomMargin: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "BN Elements"
                    }
                }

                Rectangle {
                    id: upTeamDeltaBg
                    x: 370
                    y: 145
                    width: 280
                    height: parent.height
                    color: "#00ff00"
                    radius: 0
                    border.width: 4
                    border.color: root.mainBorderColor
                    anchors.left: upTeamLapBg.right
                    anchors.verticalCenter: parent.verticalCenter
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

                    Text {
                        id: teamLabelA1
                        x: -157
                        y: 138
                        color: root.mainFontColor
                        text: qsTr("LAP GAP")
                        anchors.bottom: parent.bottom
                        font.pixelSize: 20
                        horizontalAlignment: Text.AlignHCenter
                        anchors.bottomMargin: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "BN Elements"
                    }
                }
            }

            Item {
                id: sectorGroup
                width: 660
                height: 180
                anchors.left: parent.left
                anchors.top: upGroup.bottom
                anchors.leftMargin: 20
                anchors.topMargin: 10

                Rectangle {
                    id: sector2Bg
                    x: 242
                    y: 389
                    width: sector1Bg.width
                    height: parent.height
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
                        text: qsTr("--")
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

                Rectangle {
                    id: sector3Bg
                    x: 464
                    y: 389
                    width: sector1Bg.width
                    height: parent.height
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
                        text: qsTr("--")
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
                    id: sector1Bg
                    y: 389
                    width: 215
                    height: parent.height
                    visible: true
                    color: "#00000000"
                    radius: 0
                    border.width: 4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    border.color: root.mainBorderColor
                    Text {
                        id: sector1Val
                        width: 130
                        text: qsTr("--")
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
                }


            }


        }

        Item {
            id: messagePage
            x: 0
            width: 701
            height: 512
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 36

            ColumnLayout {
                id: columnLayout
                width: parent.width
                height: parent.height
                spacing: 1
                x: parent.x
                y: parent.y


                Rectangle {
                    id: rect_temp
                    width: 650
                    height: 150
                    visible: true
                    color: "#fa4040"
                    radius: 5
                    border.color: root.mainBorderColor
                    border.width: 7
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop



                    Text {
                        //                            id: msgTempText
                        text: qsTr("ENG TEMP HIGH")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 80
                        styleColor: root.mainFontColor
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    MouseArea {
                        id: mouseArea1
                        width: 100
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                    }
                }

                Rectangle {
                    id: rect_pit
                    width: 650
                    height: 150
                    visible: true
                    color: "#ffff15"
                    radius: 5
                    border.color: root.mainBorderColor
                    border.width: 7
                    Text {
                        text: qsTr("PIT")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        styleColor: root.mainFontColor
                    }

                    MouseArea {
                        id: mouseArea2
                        width: 100
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 0
                        anchors.leftMargin: 0
                    }
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                }

                Rectangle {
                    id: rect_custom
                    width: 650
                    height: 200
                    visible: true
                    color: "#00000000"
                    radius: 5
                    border.color: root.mainBorderColor
                    border.width: 7
                    Text {
                        text: 'CUSTOM \n MESSAGE'
                        color: root.mainFontColor
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 80
                        anchors.horizontalCenter: parent.horizontalCenter
                        styleColor: root.mainFontColor
                    }

                    MouseArea {
                        id: mouseArea3
                        width: 100
                        height: 100
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                    }
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }


        }

        Item {
            id: configPage
            width: 700
            height: 512
            visible: true
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 36

            ComboBox {
                id: trackCb
                y: 119
                width: 125
                height: 40
                anchors.verticalCenter: darkmode.verticalCenter
                anchors.left: darkmode.right
                currentIndex: -1
                anchors.leftMargin: 150
                scale: 1.5
                model: ListModel {
                    id: trackList
                    ListElement { text: "TCKC"}
                    ListElement { text: "MAC"}
                    ListElement { text: "None"}
                }
                onCurrentIndexChanged: {console.log(trackList.get(currentIndex).text)}

                Text {
                    id: text2
                    text: qsTr("Select Track")
                    color: root.mainFontColor
                    anchors.bottom: parent.top
                    font.pixelSize: 16
                    minimumPixelSize: 16
                    font.family: "BN Elements"
                    anchors.bottomMargin: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                //                onAccepted: {
                //                    if (find(currentText) === -1) {
                //                        model.append({text: editText})
                //                        currentIndex = find(editText)
                //                    }
                //            }
            }
            Switch {
                id: darkmode
                width: 150
                height: 44
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 75
                anchors.topMargin: 75
                display: AbstractButton.IconOnly
                autoRepeat: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                hoverEnabled: false
                font.family: "BN Elements"
                scale: 2.0
                onPositionChanged: {root.darkMode = (root.darkMode == true) ? false : true}

                Text {
                    id: darkLabel
                    x: 60
                    y: 35
                    color: root.mainFontColor
                    text: qsTr("Dark Mode")
                    anchors.bottom: parent.top
                    font.pixelSize: 12
                    anchors.bottomMargin: -5
                    font.family: "BN Elements"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Switch {
                id: pageLoop
                x: 74
                anchors.top: darkmode.bottom
                anchors.topMargin: 150
                anchors.horizontalCenter: darkmode.horizontalCenter
                font.family: "BN Elements"
                scale: 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onPositionChanged: {
                    //pageLooper.running = !pageLooper.runing; console.log(position)}
                    pageLooper.running = (position == 1) ? true: false
                }



                Text {
                    id: loopLabel
                    x: 61
                    y: 35
                    text: qsTr("Loop Pages")
                    color: root.mainFontColor
                    anchors.bottom: parent.top
                    font.pixelSize: 12
                    anchors.bottomMargin: -5
                    font.family: "BN Elements"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }


            Button {
                id: reset
                x: 388
                y: 269
                text: qsTr("RESET")
                scale: 1.5
                font.pointSize: 16
                font.family: "BN Elements"
            }

            Button {
                id: configExit
                x: 479
                y: 423
                text: qsTr("RETURN")
                anchors.horizontalCenter: reset.horizontalCenter
                scale: 1.5
                font.pointSize: 12
                font.family: "BN Elements"
                flat: false
                onPressed: {
//                    pageR.visible = true
                    root.page = 0
                }
            }


        }

        MultiPointTouchArea {
            id: pageR
            x: 0
            y: 76
            width: 700
            height: 550
            visible: true
            anchors.top: parent.top
            anchors.topMargin: 40
            mouseEnabled: true
            maximumTouchPoints: 1
            onPressed: {root.page = (root.page != 2) ? root.page+1 : 0}
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
    D{i:0;formeditorZoom:0.6600000262260437}D{i:38;invisible:true}D{i:54;invisible:true}
D{i:55;invisible:true}D{i:56;invisible:true}D{i:60;invisible:true}D{i:46;invisible:true}
D{i:65;invisible:true}D{i:64;invisible:true}D{i:67;invisible:true}D{i:66;invisible:true}
D{i:69;invisible:true}D{i:68;invisible:true}D{i:70;invisible:true}D{i:71;invisible:true}
D{i:63;invisible:true}D{i:84;invisible:true}D{i:62;invisible:true}D{i:93;invisible:true}
}
##^##*/
