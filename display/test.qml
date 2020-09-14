import QtQuick 2.15
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0



ApplicationWindow {
    id: root
    visible: true
    color: "#cf97ba"
    width:1280
    height:800
    property var mode: "white"

    Rectangle {
        id: rectangle
        x: 246
        y: 86
        width: 200
        height: 200
        color: "#ffffff"


        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                rectangle.color = "red"

            }
            //on: {rectangle.color = "white"}
        }
    }

    Button {
        id: button
        x: 144
        y: 446
        text: qsTr("Button")
        onPressedChanged: {root.color = "gray"}
    }
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.RightButton)
                contextMenu.popup()
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized)
                contextMenu.popup()
        }

        Menu {
            id: contextMenu
            MenuItem { text: "Cut" }
            MenuItem { text: "Copy" }
            MenuItem { text: "Paste" }
        }
    }
}
/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:2}
}
##^##*/
