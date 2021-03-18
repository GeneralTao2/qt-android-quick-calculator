import QtQuick 2.0

Rectangle {
    width: parent.width/4 + 1;   height: parent.height
    y: 0
    color: "lightblue"
    Image {
        width: parent.width;     height: parent.height;
        source: "img/CobbleStone.png"
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }
    Text {
        text: qsTr("mc")
        font.pointSize: 20
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: customFont.name
        color: "white"
    }
}
