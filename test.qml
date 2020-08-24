import QtQuick 2.0



Column {
    FontLoader { id: fixedFont; name: "Courier" }
    FontLoader { id: webFont; source: "http://www.mysite.com/myfont.ttf" }
    FontLoader { id: myFont; source: "qrc:./fonts/segoesc.ttf"}

    Text { text: "Fixed-size font"; font.family: fixedFont.name }
    Text { text: "Fancy font"; font.family: myFont }
    Text { text: "99"; font.bold: true; font.italic: true; font.pointSize: 100; font.family: "Mont Heavy DEMO" }
}
/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
