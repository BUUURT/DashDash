import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.0
import QtGraphicalEffects 1.0
import QtCharts 2.15

ApplicationWindow {
    id: root
    color: root.mainBgColor
    visible: true
    width:1280
    height:800
    Rectangle {
         width: 150
         height: 150
         Canvas {
                anchors.fill: parent
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();

                    var centreX = width / 2;
                    var centreY = height / 2;

                    ctx.beginPath();
                    ctx.fillStyle = "black";
                    ctx.moveTo(centreX, centreY);
                    ctx.arc(centreX, centreY, width / 4, 0, Math.PI * 0.5, false);
                    ctx.lineTo(centreX, centreY);
                    ctx.fill();

                    ctx.beginPath();
                    ctx.fillStyle = "red";
                    ctx.moveTo(centreX, centreY);
                    ctx.arc(centreX, centreY, width / 4, Math.PI * 0.5, Math.PI * 2, false);
                    ctx.lineTo(centreX, centreY);
                    ctx.fill();
                }
            }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
