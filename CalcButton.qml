import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.12

Button {
    property alias imageSource: name.source
    property alias mytext: textProps.text
    property alias textColor: textProps.color
    property var changeState: function() {
        overley.color = enabled ? "#50000000" : "#00000000"
        enabled = !enabled
    }
    property var setGeometry: function (X, Y, Width, Height) {
        x = X
        y = Y
        width = Width+1
        height = Height+1
        name.width = width;     name.height = height;
    }
    property var releaseHandler: function () {
        name.x = 0; name.y = 0
        name.width = width;     name.height = height;
        overley.color = "#00000000"
        xyNegAnim.running = true
        wNegAnim.running = true
        hNegAnim.running = true
    }

    width: parent.width/4 + 1
    height: parent.height/5 + 1

    Image {
        id: back
        source: "img/woods.ico"
        width: parent.width;     height: parent.height;
        fillMode: Image.PreserveAspectCrop
        smooth: false
        ColorOverlay {
            anchors.fill: back
            source: back
            color: "#50000000"
           }
    }
    Image {
        id: name
        source: "img/Log2.png"
        width: parent.width;     height: parent.height;
        fillMode: Image.PreserveAspectCrop
        smooth: false
        Text {
            width: parent.width;     height: parent.height;
            id: textProps;
            text: parent.parent.text
            //font.pointSize: 20
            font.pixelSize: width/2.5
            font.family: customFont.name
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    ColorOverlay {
        id: overley
        anchors.fill: name
        source: name
        color: "#00000000"
       }
    PropertyAnimation {
        id: xyPosAnim
        targets: [name]
        properties: "x, y"
        from: 0; to: 3; duration: 50
        running: false
    }
    PropertyAnimation {
        id: wPosAnim
        targets: [textProps, name]
        property: "width"
        from: width; to: width - 3; duration: 50
        running: false
    }
    PropertyAnimation {
        id: hPosAnim
        targets: [textProps, name]
        property: "height"
        from: height; to: height - 3; duration: 50
        running: false
    }

    PropertyAnimation {
        id: xyNegAnim
        targets: [name]
        properties: "x, y"
        from: 3; to: 0; duration: 50
        running: false
    }
    PropertyAnimation {
        id: wNegAnim
        targets: [name, textProps]
        property: "width"
        from: width - 3; to: width; duration: 50
        running: false
    }
    PropertyAnimation {
        id: hNegAnim
        targets: [name, textProps]
        property: "height"
        from: height - 3; to: height; duration: 50
        running: false
    }

    onPressed: {
        name.x = 3; name.y = 3
        name.width = width - 3;     name.height = height - 3;
        overley.color = "#20000000";
        xyPosAnim.running = true
        wPosAnim.running = true
        hPosAnim.running = true
    }
    onReleased: {
        if(this === keyboard.keyChmode) {
            return
        }
        releaseHandler()
    }
}
