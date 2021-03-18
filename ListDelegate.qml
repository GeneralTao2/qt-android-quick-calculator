import QtQuick 2.0

Item {
    id: itemDelegate
    property string name: "NONE"

    Text {
        text: name
        font.pointSize: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        font.family: customFont.name
        color: "#595959"
    }
}
