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
        width: 1200
        height: 800
        Button {
            id: darkmode
            x: 1182
            y: 700
            text: qsTr("DARK")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: -82
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
            id: raceData
            y: 530
            width: 500
            height: 200
            anchors.left: parent.left
            anchors.leftMargin: 30

            Text {
                id: lastLap
                text: qsTr("0:00:00")
                color: root.mainFontColor
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pixelSize: 125

                Text {
                    id: labelLast
                    x: 0
                    y: -23
                    text: qsTr("LAST")
                    color: root.mainFontColor
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: 270
                    anchors.left: parent.left
                    anchors.leftMargin: -35
                    font.underline: false
                    font.italic: false
                    font.pixelSize: 20
                }
            }

            Text {
                id: racePosP
                text: qsTr("P")
                anchors.left: parent.right
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                color: root.mainFontColor
                font.pixelSize: 100

                Text {
                    id: racePosNum
                    y: 9
                    text: qsTr("18")
                    color: root.mainFontColor
                    anchors.left: parent.left
                    anchors.leftMargin: 50
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 100
                }
            }

            Text {
                id: lapNum
                text: qsTr("300")
                anchors.top: parent.top
                anchors.topMargin: 100
                anchors.left: parent.right
                anchors.leftMargin: 0
                color: root.mainFontColor
                anchors.right: parent.right
                anchors.rightMargin: 0
                font.pixelSize: 100

                Text {
                    id: lapL
                    y: 81
                    text: qsTr("L")
                    color: root.mainFontColor
                    anchors.left: parent.left
                    anchors.leftMargin: -50
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 100
                }
            }

            Rectangle {
                id: speedBg
                x: 171
                y: -360
                width: 462
                height: 363
                color: root.mainBgColorSub
                radius: 50
                anchors.right: parent.right
                anchors.rightMargin: -150
                border.width: 0

                Text {
                    id: speed
                    x: 117
                    y: 125
                    color: root.mainFontColor
                    text: qsTr("99")

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 400
                }

            }
        }

        Item {
            id: position
            width: 200
            height: 200
        }

        Item {
            id: bikeData
            width: 200
            height: 200
        }

        Text {
            id: element
            x: 757
            y: 173
            text: qsTr("150F")
            font.pixelSize: 70
        }

        Text {
            id: element1
            x: 700
            y: 297
            text: qsTr("500f")
            font.pixelSize: 70
        }
    }

    Item {
        id: pitComms
        y: 206
        width: 155
        height: 594
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Button {
            id: pitMain
            x: -660
            text: qsTr("PIT")

            anchors.horizontalCenterOffset: 27
            padding: 10
            font.pointSize: 50
            checkable: true
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                implicitWidth: 160
                implicitHeight: 300
                color: pitMain.checked ? "red" : root.mainBgColor
                border.color: root.mainFontColor
                border.width: 2
                radius: 20
            }
        }


    }




}






/*##^##
Designer {
    D{i:45;anchors_x:"-64";anchors_y:"-23"}D{i:44;anchors_x:"-64";anchors_y:0}D{i:47;anchors_x:5}
D{i:46;anchors_x:10;anchors_y:120}D{i:49;anchors_x:150}D{i:48;anchors_x:5;anchors_y:120}
D{i:43;anchors_x:180}D{i:58;anchors_y:"-58"}D{i:57;anchors_y:"-58"}D{i:56;anchors_x:688}
}
##^##*/
