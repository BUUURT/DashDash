import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    Rectangle {
        id: rectangle
        x: 99
        y: 124
        width: 450
        height: 200
        color: "#eacccc"

        Button {
            id: button
            x: 127
            y: 70
            text: qsTr("Button")
            anchors.horizontalCenter: parent.horizontalCenter
            onPressedChanged: {rectangle.color = 'blue'}

        }

        Slider {
            id: slider
            x: 77
            y: 146
            width: 400
            anchors.horizontalCenter: parent.horizontalCenter
            value: 0.5
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
