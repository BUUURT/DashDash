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
    width:1920
    height:1080
//    visibility: "FullScreen"

    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            rectangle.visible = !rectangle.visible

        }
    }

    Image {
        anchors.verticalCenter: parent.verticalCenter
        source: "test.png"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 1920
        height: 1080
        color: "#ff0000"
        visible: true
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
