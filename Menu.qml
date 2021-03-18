import QtQuick 2.0

Rectangle {
    x: 0; y: 0;
    MenuButton {
        x: 0
    }

    MenuButton {
        x: parent.width/4
    }

    MenuButton {
        x: parent.width/2
    }

    MenuButton {
        x: 3*parent.width/4
    }
}
