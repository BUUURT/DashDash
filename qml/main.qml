import QtQuick 2.0

Rectangle {
  id:test
  color: "red"
  width: 400
  height: 400

  Text {
    text: "Hello, world!"
    anchors.centerIn: parent
    font.pointSize: 24
    font.bold: true
   }
}
