import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.10
import QtQuick.Window 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtQuick 2.0

ApplicationWindow {
    width: 800
    height: 480
    id: core
    visible: true
    Rectangle {
        id: background
        x: 0
        y: 0
        width: core.width
        height: core.height
//        width: 800
//        height: 480
        color: "#282828"

        Text {
            id: speedo
            x: 155
            y: 136
            color: "#ffffff"
            text: qsTr("99")
            style: Text.Outline
            font.weight: Font.DemiBold
            font.capitalization: Font.MixedCase
            font.italic: false
            font.bold: false
            font.family: "Tahoma"
            font.pixelSize: 250

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered:
                    speedo.text = con.speed();


            }

        }

        GridLayout {
            id: rpmLayout
            x: 0
            y: 30
            width: 800
            height: 100
            columns: 13

            Timer {
                interval: 10
                running: true
                repeat: true
                onTriggered: {
                    rpm1.opacity = con.rpm(1)
                    rpm2.opacity = con.rpm(2)
                    rpm3.opacity = con.rpm(3)
                    rpm4.opacity = con.rpm(4)
                    rpm5.opacity = con.rpm(5)
                    rpm6.opacity = con.rpm(6)
                    rpm7.opacity = con.rpm(7)
                    rpm8.opacity = con.rpm(8)
                    rpm9.opacity = con.rpm(9)
                    rpm10.opacity = con.rpm(10)
                    rpm11.opacity = con.rpm(11)
                    rpm12.opacity = con.rpm(12)
                    rpm13.opacity = con.rpm(13)
                }
            }

            Rectangle {
                id: rpm1
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1

                Text {
                    id: element
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("1")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                }
            }

            Rectangle {
                id: rpm2
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1

                Text {
                    id: element1
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("2")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm3
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1

                Text {
                    id: element2
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("3")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm4
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1


                Text {
                    id: element3
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("4")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm5
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1

                Text {
                    id: element4
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("5")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm6
                width: 40
                height: 75
                color: "#ffffff"
                opacity: 0.1

                Text {
                    id: element5
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("6")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm7
                width: 40
                height: 75
                color: "#ffef11"
                opacity: 0.1

                Text {
                    id: element6
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("7")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm8
                width: 40
                height: 75
                color: "#ffef11"
                opacity: 0.1

                Text {
                    id: element7
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("8")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm9
                width: 40
                height: 75
                color: "#00fb45"
                opacity: 0.1

                Text {
                    id: element8
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("9")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm10
                width: 40
                height: 75
                color: "#04ff49"
                opacity: 0.1

                Text {
                    id: element9
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("10")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm11
                width: 40
                height: 75
                color: "#04ff49"
                opacity: 0.1

                Text {
                    id: element10
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("11")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm12
                width: 40
                height: 75
                color: "#ff1111"
                opacity: 0.1

                Text {
                    id: element11
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("12")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Rectangle {
                id: rpm13
                width: 40
                height: 75
                color: "#ff1111"
                opacity: 0.1

                Text {
                    id: element12
                    x: 0
                    color: "#f9f9f9"
                    text: qsTr("13")
                    anchors.top: parent.top
                    anchors.topMargin: 83
                    font.pixelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

}
