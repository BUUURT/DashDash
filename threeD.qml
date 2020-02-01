import QtQuick 2.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls 2.3

ApplicationWindow {
    id: element
    visible: true
    Page {
        id: page
        x: 0
        y: 0
        width: 640
        height: 480
        wheelEnabled: false

        Dial {
            id: dial
            x: 77
            y: 238
            live: true
            stepSize: 20
            value: 0.24
            to: 400
            from: 0
            wheelEnabled: false
            onValueChanged: {
                rectangle.height = dial.value
            }
        }

        Dial {
            id: dial1
            x: 385
            y: 238
            from: 0
            stepSize: 50
            to: 400

            onValueChanged: {
                rectangle.width = dial1.value
            }
        }

        Rectangle {
            id: rectangle
            x: 208
            y: 26
            width: 200
            height: 200
            color: "#6b4343"

            Text {
                id: label
                x: 48
                y: 51
                color: "#f9f9f9"
                text: rectangle.height
                font.pointSize: 47
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
