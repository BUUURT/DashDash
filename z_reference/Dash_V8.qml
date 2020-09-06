import QtQuick 2.0
import QtQuick.Window 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0



ApplicationWindow {
    id: root
    //    color: mainBgColor
    visible: true
    width:1280
    height:800
    color: mainBgColor

    property color mainFontColor: "black"
    property color mainBgColor: "white"
    property color mainBgColorSub: "#eaeaea"
    property color mainAccentColor: "darkblue"
    property int rpm: 0
    property int speed: 0
    property color rpmColor: "#4d6278"
    property int shiftGreen: 7000
    property int shiftYellow: 10000
    property int shiftRed: 11500
    property int shiftRedFlash: 12000


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
            positionNumber.text = '2'
            lapNumber.text = '123'
            lapTimeSelf.text = '0:49.431'


        }
    }

    Behavior on rpm {
        NumberAnimation { properties: "rpm"; duration: 1000 }

    }


    onRpmChanged: {
        // drive RPM animation
        if (rpm<4000) {
            rpmSweepLow.rotation = rpm*90/4000
            rpmSweepHigh.width = 0
        }
        if (rpm>4000) {
            rpmSweepLow.rotation = 90
            rpmSweepHigh.width = (rpm-4000)*1015/11000
        }

        // set color and behavior of shift light
        var rpmGreen = parseInt(root.shiftGreen)
        var rpmYellow = parseInt(root.shiftYellow)
        var rpmRed = parseInt(root.shiftRed)
        var rpmFlash = parseInt(root.shiftRedFlash)

        if (rpm < rpmGreen) {rpmColor = "#4d6278"}  // out of powerband, blue RPM
        if (rpm < rpmYellow && rpm > rpmGreen) {rpmColor = "#00ff00"}  //start powerband, green
        if (rpm < rpmRed && rpm > rpmYellow) {rpmColor = "#ffff00"} //yellow
        if (rpm > rpmRed) {rpmColor = "#ff0000"} //red

        //adjust rpm font label size
        label0.font.pixelSize = (0 < root.rpm && root.rpm < 1000) ? 20 : 15
        label1.font.pixelSize = (1000 < root.rpm && root.rpm < 2000) ? 20 : 15
        label2.font.pixelSize = (2000 < root.rpm && root.rpm < 3000) ? 20 : 15
        label3.font.pixelSize = (3000 < root.rpm && root.rpm < 4000) ? 25 : 15
        label4.font.pixelSize = (4000 < root.rpm && root.rpm  < 5000) ? 30 : 16
        label5.font.pixelSize = (5000 < root.rpm && root.rpm < 6000) ? 40 : 17
        label6.font.pixelSize = (6000 < root.rpm && root.rpm < 7000) ? 40 :17
        label7.font.pixelSize = (7000 < root.rpm && root.rpm  < 8000) ? 40 :17
        label8.font.pixelSize = (8000 < root.rpm && root.rpm  < 9000) ? 40 :17
        label9.font.pixelSize = (9000 < root.rpm && root.rpm  < 10000) ? 40 :17
        label10.font.pixelSize = (10000 < root.rpm && root.rpm  < 11000) ? 40 :17
        label11.font.pixelSize = (11000 < root.rpm && root.rpm  < 12000) ? 40 :17
        label12.font.pixelSize = (12000 < root.rpm && root.rpm  < 13000) ? 40 :17
        label13.font.pixelSize = (13000 < root.rpm && root.rpm < 14000) ? 40 :17
        speed.text = root.speed



    }

    Rectangle {
        id: rpmSweepHigh
        x: 166
        y: 0
        width: 0
        height: 291
        color: root.rpmColor
        //        onWidthChanged: {element.text = width}
    }

    Rectangle {
        id: rpmSweepLow
        x: -38
        y: 164
        width: 204
        height: 250
        color: root.rpmColor
        opacity: 1
        rotation: 0
        transformOrigin: Item.TopRight

    }



    Image {
        id: baselayer
        source: "rpmScreen.png"
        x: 0
        y: 0
        opacity: 1

        ColorOverlay {
            x: 0
            y: 0
            color: root.mainBgColor
            anchors.fill: baselayer
            source: baselayer
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0


        }
    }



    Item {
        id: rpmLabels
        x: -8
        y: 12
        width: 200
        height: 200

        Item {
            id: block0
            x: -29
            y: -48
            width: 200
            height: 200
            transformOrigin: Item.BottomRight
            rotation: 0

            Rectangle {
                id: stub0
                x: 127
                y: 192
                width: 8
                height: 2
                color: root.mainFontColor
                rotation: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 37
                transformOrigin: Item.BottomRight
            }
        }
        Item {
            id: block1
            x: -29
            y: -48
            width: 200
            height: 200
            transformOrigin: Item.BottomRight
            rotation: 22.5

            Rectangle {
                id: stub1
                x: 127
                y: 192
                width: 8
                height: 2
                color: root.mainFontColor
                rotation: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 37
                transformOrigin: Item.BottomRight
            }
        }
        Item {
            id: block2
            x: -29
            y: -48
            width: 200
            height: 200
            transformOrigin: Item.BottomRight
            rotation: 45

            Rectangle {
                id: stub2
                x: 127
                y: 192
                width: 8
                height: 2
                color: root.mainFontColor
                rotation: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 37
                transformOrigin: Item.BottomRight
            }
        }
        Item {
            id: block3
            x: -29
            y: -48
            width: 200
            height: 200
            transformOrigin: Item.BottomRight
            rotation: 67.5

            Rectangle {
                id: stub3
                x: 127
                y: 192
                width: 8
                height: 2
                color: root.mainFontColor
                rotation: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 37
                transformOrigin: Item.BottomRight
            }
        }

        GridLayout {
            id: gridLayout
            x: 172
            y: -22
            width: 1006
            height: 268
            rowSpacing: 1
            columnSpacing: 0
            columns: 11

            Rectangle {
                id: stub4
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label4
                    x: -9
                    color: root.mainFontColor
                    text: qsTr("4")
                    font.weight: Font.Normal
                    font.pixelSize: 15
                    anchors.topMargin: 5
                    anchors.top: parent.top
                    style: Text.Normal
                    anchors.horizontalCenter: parent.horizontalCenter
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce4
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub5
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label5
                    x: -9
                    color: root.mainFontColor
                    text: qsTr("5")
                    font.weight: Font.Normal
                    font.pixelSize: 15
                    anchors.topMargin: 5
                    anchors.top: parent.top
                    style: Text.Normal
                    anchors.horizontalCenter: parent.horizontalCenter
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce5
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }


                }
            }

            Rectangle {
                id: stub6
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label6
                    x: -9
                    text: qsTr("6")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce6
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub7
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label7
                    x: -9
                    text: qsTr("7")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce7
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub8
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label8
                    x: -9
                    text: qsTr("8")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce8
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub9
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label9
                    x: -9
                    text: qsTr("9")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor

                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce9
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub10
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label10
                    x: -9
                    text: qsTr("10")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce10
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub11
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label11
                    x: -9
                    text: qsTr("11")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce11
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }

            Rectangle {
                id: stub12
                width: 2
                height: 8
                color: root.mainFontColor
                Text {
                    id: label12
                    x: -9
                    text: qsTr("12")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce12
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1
                            }
                        }
                    }
                }
            }


            Rectangle {
                id: stub13
                width: 2
                height: 8
                color: root.mainFontColor

                Text {
                    id: label13
                    x: -9
                    text: qsTr("13")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    font.pixelSize: 15
                    color: root.mainFontColor
                    style: Text.Normal
                    font.weight: Font.Normal
                    styleColor: root.mainAccentColor
                    Behavior on font.pixelSize{
                        NumberAnimation {
                            id: fontbounce13
                            duration: 1000
                            easing {
                                type: Easing.OutElastic
                                amplitude: 1
                                period: 1

                            }
                        }
                    }
                }
            }



        }

        Text {
            id: label3
            x: -4
            y: 2
            color: root.mainFontColor
            text: qsTr("3")
            anchors.horizontalCenterOffset: 62
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 114
            font.pixelSize: 15
            anchors.top: parent.top
            style: Text.Normal
            font.weight: Font.Normal
            styleColor: root.mainAccentColor
            Behavior on font.pixelSize{
                NumberAnimation {
                    id: fontbounce3
                    duration: 1000
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1

                    }
                }
            }
        }

        Text {
            id: label2
            x: 4
            y: 16
            color: root.mainFontColor
            text: qsTr("2")
            anchors.horizontalCenterOffset: 51
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 15
            anchors.topMargin: 119
            anchors.top: parent.top
            style: Text.Normal
            font.weight: Font.Normal
            styleColor: root.mainAccentColor
            Behavior on font.pixelSize{
                NumberAnimation {
                    id: fontbounce2
                    duration: 1000
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1

                    }
                }
            }
        }

        Text {
            id: label1
            x: 7
            y: 11
            color: root.mainFontColor
            text: qsTr("1")
            anchors.horizontalCenterOffset: 41
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 128
            font.pixelSize: 15
            anchors.top: parent.top
            style: Text.Normal
            font.weight: Font.Normal
            styleColor: root.mainAccentColor
            Behavior on font.pixelSize{
                NumberAnimation {
                    id: fontbounce1
                    duration: 1000
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1

                    }
                }
            }
        }

        Text {
            id: label0
            x: 4
            y: 6
            color: root.mainFontColor
            text: qsTr("0")
            font.bold: false
            anchors.horizontalCenterOffset: 39
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 15
            anchors.topMargin: 142
            anchors.top: parent.top
            style: Text.Normal
            font.weight: Font.Normal
            styleColor: root.mainAccentColor
            Behavior on font.pixelSize{
                NumberAnimation {
                    id: fontbounce0
                    duration: 1000
                    easing {
                        type: Easing.OutElastic
                        amplitude: 1
                        period: 1

                    }
                }
            }

        }

    }


    Item {
        id: base
        width: 1280
        height: 800

        Button {
            id: darkmode
            x: -216
            y: 625
            text: qsTr("DARK")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 75
            anchors.right: parent.right
            anchors.rightMargin: 1316
            padding: 4
            font.pointSize: 20
            checkable: true
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 100
                color: darkmode.checked ? "gray" : root.mainBgColor
                border.color: root.mainFontColor
                border.width: 2
                radius: 70

            }
            onCheckedChanged: {
                root.mainBgColor = (root.mainBgColor == "#000000") ? "#ffffff" : "#000000"
                root.mainFontColor = (root.mainFontColor == "#000000") ? "#ffffff" : "#000000"
                root.mainBgColorSub = (root.mainBgColorSub == "#353535") ? "#eaeaea" : "#353535"
            }
        }

        Item {
            id: bikeData
            width: 500
            height: 500
            anchors.top: parent.top
            anchors.topMargin: 200
            anchors.left: parent.left
            anchors.leftMargin: 0

            Rectangle {
                id: speedBg
                width: 500
                height: 400
                color: "#e2e1e1"
                radius: 15
                anchors.left: parent.left
                anchors.leftMargin: 50

                Text {
                    id: speedText
                    text: qsTr("55")
                    anchors.top: parent.top
                    anchors.topMargin: -70
                    anchors.horizontalCenterOffset: -10
                    font.bold: true
                    font.italic: true
                    font.family: "Mont Heavy DEMO"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 1.1*parent.height

                }

                Text {
                    id: speedLabel
                    x: -1
                    y: 2
                    text: qsTr("MPH")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    font.pixelSize: 0.1*parent.height
                    font.family: "Mont ExtraLight DEMO"
                    font.italic: true
                    font.bold: false
                }
            }

            Rectangle {
                id: engTemp
                x: -5
                width: 175
                height: 75
                color: "#e2e1e1"
                radius: 15
                anchors.top: speedBg.bottom
                anchors.topMargin: 5
                Text {
                    id: speedText1
                    text: qsTr("220")
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: parent.height
                    font.family: "Mont Heavy DEMO"
                    font.italic: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }

                Text {
                    id: speedText2
                    y: 2
                    text: qsTr("°F")
                    anchors.verticalCenterOffset: -10
                    font.pixelSize: 35
                    anchors.left: speedText1.right
                    anchors.leftMargin: 5
                    font.italic: true
                    font.family: "Mont Heavy DEMO"
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }

                Text {
                    id: speedText3
                    x: 132
                    y: 65
                    text: qsTr("ENGINE")
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    rotation: 0
                    font.pixelSize: 20
                    anchors.verticalCenterOffset: 50
                    font.family: "Mont ExtraLight DEMO"
                    font.italic: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: false
                }
                anchors.left: parent.left
                anchors.leftMargin: 50
            }

            Rectangle {
                id: brakeTemp
                x: -10
                y: 0
                width: 175
                height: 75
                color: "#e2e1e1"
                radius: 15
                Text {
                    id: speedText4
                    text: qsTr("475")
                    font.pixelSize: parent.height
                    font.italic: true
                    font.family: "Mont Heavy DEMO"
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                }

                Text {
                    id: speedText5
                    y: 2
                    text: qsTr("°F")
                    font.pixelSize: 35
                    anchors.verticalCenterOffset: -10
                    font.family: "Mont Heavy DEMO"
                    font.italic: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    anchors.left: speedText4.right
                    anchors.leftMargin: 5
                }

                Text {
                    id: speedText6
                    y: -4
                    text: qsTr("BRAKE")
                    font.pixelSize: 20
                    anchors.verticalCenterOffset: 50
                    font.italic: true
                    font.family: "Mont ExtraLight DEMO"
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: 0
                    font.bold: false
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                }
                anchors.topMargin: 5
                anchors.left: engTemp.right
                anchors.leftMargin: 20
                anchors.top: speedBg.bottom
            }
        }


    }




}






/*##^##
Designer {
    D{i:41;invisible:true}D{i:49;anchors_x:8}D{i:50;anchors_x:8}D{i:47;anchors_y:3}D{i:53;anchors_x:8}
D{i:54;anchors_x:8}D{i:51;anchors_y:3}
}
##^##*/
