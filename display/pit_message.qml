import QtQuick 2.0

Item {
    id: item1
    width: 700
    height: 500

    Rectangle {
        id: rectangle
        x: 250
        y: 98
        width: 400
        height: 225
        color: "#f20000"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: text1
            x: 88
            y: 86
            text: qsTr("PIT")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 200
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: rectangle1
            x: -350
            y: -142
            width: 210
            height: 5
            color: "#f20000"
            anchors.right: parent.left
            anchors.bottom: parent.top
            transformOrigin: Item.BottomRight
            rotation: 42
            anchors.bottomMargin: -5
            anchors.rightMargin: -5
        }

        Rectangle {
            id: rectangle2
            x: 545
            y: 358
            width: 210
            height: 5
            color: "#f20000"
            anchors.left: parent.right
            anchors.top: parent.bottom
            anchors.leftMargin: -5
            anchors.topMargin: -5
            rotation: 42
            transformOrigin: Item.BottomRight
        }
    }

}
