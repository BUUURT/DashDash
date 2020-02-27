import QtQuick 2.0
import QtQuick.Window 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0

// @disable-check M16
ApplicationWindow {
    id: root
    width: 2000
    height: 1200
    color: "#dbb5b5"
    visible: true

    Button {
        id: button
        x: 936
        y: 334
        width: 150
        height: 80
        text: qsTr("Button")
        wheelEnabled: false
        autoExclusive: false



    }

    Connections {
        target: button
        onClicked: {

                if (rectangle.state == "light") {rectangle.state = "dark"}
                else {rectangle.state = "light"}
            }

//    myRect.state == 'clicked' ? myRect.state = "" : myRect.state = 'clicked';
        }




    Text {
        id: element
        y: 0
        text: "test"
        anchors.left: parent.left
        anchors.leftMargin: 88
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 131

    }

    Rectangle {
        id: rectangle
        x: 1130
        y: 558
        width: 200
        height: 200
        state: "light"
        states: [
            State {
                name: "dark"
                PropertyChanges { target: rectangle; color: "black" }
                PropertyChanges { target: root; color: "grey" }
            },
            State {
                name: "light"
                PropertyChanges { target: rectangle; color: "grey" }
                PropertyChanges { target: root; color: "white" }
            }
        ]

        onStateChanged: {element.text = rectangle.state}


    }

    Image {
        id: image
        x: 398
        y: 509
        width: 610
        height: 623
        source: "z_reference/cockpit-mm931.jpg"
        fillMode: Image.PreserveAspectFit

    }
    ColorOverlay {
        anchors.fill: image
        source: image
        color: "blue"
        opacity: 0.5
    }

}


/*##^##
Designer {
    D{i:3;anchors_x:0}
}
##^##*/
