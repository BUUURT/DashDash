import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: item1
    Rectangle {
        id: rectangle
        x: 0
        y: 102
        width: 300
        height: 100
        color: "#f86060"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: button
            x: 270
            y: 118
            text: qsTr("Button")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            onPressed: {rectangle.color = 'blue'}
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
