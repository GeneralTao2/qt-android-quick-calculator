import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.12

Button {
    id: itemDelegate
    property string name: "NONE"
    property string bgColor: "white"
    property string bgBorderColor: "white"
    property int expression: Keyboard.Action.NONE
    checkable: true
    background: Control {
        padding: 2
        //topPadding: -2
        bottomPadding: -1
        rightPadding: -1
        background: Rectangle {
            id: bg
            radius: 4
            color: bgColor
            border.color: bgBorderColor
        }
        contentItem:  Text {
            id: textProps;
            text: name
            font.pixelSize: 25
            font.family: customFont.name
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
