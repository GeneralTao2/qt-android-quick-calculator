import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.3


Window {
    id: root
    visible: true
    width: 270
    height: 585
    title: qsTr("Hello World Calculator")
    color: "lightblue"
    FontLoader {
          id: customFont
          source: "other/PixelMiners-KKal.otf"
     }

    Item {
        width: parent.width
        anchors.top: menuRow.bottom
        anchors.bottom: display.top
        ListModel {
            id: myModel
            ListElement { name: "64+81-82/2*4=126";}
            ListElement { name: "1+4-5*0=0";}
            ListElement { name: "1*1/1*1=1"; }
            ListElement { name: "1*1/1*1=1"; }
        }
        Component {
            id: myDelegate
            ListDelegate {
                name: model.name
                width: parent.width
                height: 30
            }
        }
        ListView {
            id: myList
            delegate: myDelegate
            model: myModel
            anchors.topMargin: 10
            anchors.fill: parent
        }
        Rectangle {
            width: parent.width
            height: parent.height
            gradient: Gradient {
                    GradientStop { position: 0.0; color: "lightblue" }
                    GradientStop { position: 0.8; color: "#00000000" }
                    GradientStop { position: 1.0; color: "#00000000" }
                }
        }

    }
    Menu {
        id: menuRow
        width: parent.width;
        height: parent.width/8;
        /*Text {
            property double value: 0
            id: dispText
            text: qsTr("0")
            font.pointSize: 20
            anchors.fill: parent
            anchors.rightMargin: 10
            anchors.topMargin: 15
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignRight
            font.family: customFont.name
        }*/
    }
    Rectangle {
        id: display
        color: "lightgreen"
        anchors.bottom: keyboard.top
        y: parent.width/8
        width: parent.width
        height: 95
        Expression {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 15
            id: myExpr
        }

        Text {
            property double value: 0
            id: resText
            text: qsTr("=0")
            font.pointSize: 20
            anchors.fill: parent
            anchors.rightMargin: 10;
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignRight
            font.family: customFont.name
        }
        PropertyAnimation {
            id: resTextAnim
            target: resText
            property: "font.pointSize"
            from: 20; to: 30; duration: 150
            running: false
        }
    }


    Keyboard {
        id: keyboard
        width: parent.width
        height: 5*parent.width/4
        x: 0; y: parent.height - 5*parent.width/4
    }
}
