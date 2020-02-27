import QtQuick 2.0
import QtQuick.Window 2.4
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0




ApplicationWindow {
    id: root

    visible: true
    width:1280
    height:800
    color: "white"
    property int rpm: 0
        Behavior on rpm {
            NumberAnimation { properties: "rpm"; duration: 10000;   easing {type: Easing.OutBack; overshoot: 5}
            }}



    onRpmChanged: {rectangle.rotation = rpm}

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            root.rpm = con.rand()

        }
    }
    Rectangle {

        id: rectangle
        x: 17
        y: 239
        width: 1160
        height: 200
        color: "#d23a3a"
        rotation: 0

        }
    }



