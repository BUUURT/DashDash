import QtQuick 2.0



}

Rectangle {
   color: "lightgray"
   width: 400
   height: 400



   Text {
       id: words
       text: "Hello, world!"
       anchors.centerIn: parent
       font.pointSize: 24
       font.bold: true       
       function updateText() {
           words.text = con.phrase}
   }
}


