import QtQuick 2.0

Rectangle {
    enum Action {
            PLUS,
            MINUS,
            MULT,
            DIVISION,
            DIGITAL,
            NONE
    }
    property bool pointMode: false
    property int editTarget: -1
    property bool firstEdit: true
    property bool advanced: false
    function intValueHandler(key) {
        if(editTarget < 0) {
            if(resText.font.pointSize != 20) {
                resText.font.pointSize = 20
                myExpr.editAction(0, key, Keyboard.Action.DIGITAL)
            } else if (myExpr.getNameAsStr(0) === "0") {
                myExpr.editAction(0, key, Keyboard.Action.DIGITAL)
            } else {
                myExpr.editAction(0, myExpr.getNameAsStr(0) + key, Keyboard.Action.DIGITAL)
            }
        } else {
            if(firstEdit || (myExpr.getNameAsStr(editTarget) === "0") ) {
                myExpr.editAction(editTarget, key, Keyboard.Action.DIGITAL)
                firstEdit = false
            } else {
                myExpr.editAction(editTarget, myExpr.getNameAsStr(editTarget) + key, Keyboard.Action.DIGITAL)
            }
        }
    }
    function doubleValueHandler() {
        pointMode = true
        if(editTarget < 0) {
            if(resText.font.pointSize != 20) {
                resText.font.pointSize = 20
                myExpr.editAction(0, "0.", Keyboard.Action.DIGITAL)
            } else if (myExpr.getNameAsStr(0) === "0") {
                myExpr.editAction(0, "0.", Keyboard.Action.DIGITAL)
            } else {
                myExpr.editAction(0, myExpr.getNameAsStr(0) + ".", Keyboard.Action.DIGITAL)
            }
        } else {
            if(firstEdit) {
                myExpr.editAction(editTarget, "0.", Keyboard.Action.DIGITAL)
                firstEdit = false
            } else {
                myExpr.editAction(editTarget, myExpr.getNameAsStr(editTarget) + ".", Keyboard.Action.DIGITAL)
            }
        }
    }

    function degitKeyHandler(key) {
        if(myExpr.getAction(0) !== Keyboard.Action.DIGITAL && editTarget < 0) {
            myExpr.addToRight(key.mytext, Keyboard.Action.DIGITAL)
        }
        if(myExpr.getNameAsStr(0).length > 13) {
            return
        }

        if(key === ".") {
            if(!pointMode) {
                doubleValueHandler()
            }
        } else {
            intValueHandler(key)
        }
        resText.text = "=" + myExpr.getResult().toString()
    }

    function actionKeyHandler(key) {
        if(resText.font.pointSize != 20) {
            resText.font.pointSize = 20
            var result = myExpr.getResult()
            myExpr.clear()
            myExpr.editAction(0, result.toString(), Keyboard.Action.DIGITAL)
        }
        if(editTarget < 0) {
            if(myExpr.getAction(0) === Keyboard.Action.DIGITAL) {
                myExpr.addToRight(key.mytext, key.keyAction)
            } else {
                myExpr.editAction(0, key.mytext, key.keyAction);
            }
        } else {
            myExpr.editAction(editTarget, key.mytext, key.keyAction);
        }

        pointMode = false
        resText.text = "=" + myExpr.getResult().toString()
    }

    function resKeyHandler() {
        console.log("omg2")
        if(editTarget < 0) {
            if(myExpr.getAction(0) !== Keyboard.Action.DIGITAL) {
                myExpr.removeFromRight()
            }
            if(resText.font.pointSize == 20) {
                resTextAnim.running = true
                resText.text = "=" + myExpr.getResult().toString()
                myModel.append({"name": myExpr.getExpression() + resText.text})
                myList.positionViewAtEnd()
                pointMode = false
            }
        } else {
            myExpr.disableAction(editTarget)
            if(myExpr.getAction(editTarget) === Keyboard.Action.DIGITAL) {
                changeActionState()
            } else {
                changeDigitalState()
            }
            key_RESULT.mytext = "="
            key_RESULT.textColor = "#e2d4c0"
            editTarget = -1
        }
    }

    function delKeyHandler() {
        if(editTarget < 0) {
            if(myExpr.getAction(0) === Keyboard.Action.DIGITAL) {
                if(myExpr.getNameAsStr(0).length === 1) {
                    if(myExpr.length() === 1) {
                        myExpr.editAction(0, "0", Keyboard.Action.DIGITAL)
                    } else {
                        myExpr.removeFromRight()
                    }
                } else {
                    myExpr.editAction(0, myExpr.getNameAsStr(0).slice(0, -1), Keyboard.Action.DIGITAL)
                }
            } else {
                myExpr.removeFromRight()
            }
        } else {
            if(myExpr.getNameAsStr(editTarget).length === 1) {
                myExpr.editAction(editTarget, "0", Keyboard.Action.DIGITAL)
            } else {
                myExpr.editAction(editTarget, myExpr.getNameAsStr(editTarget).slice(0, -1), Keyboard.Action.DIGITAL)
            }
        }
        resText.text = "=" + myExpr.getResult().toString()
    }

    function cKeyHandler() {
        if(editTarget < 0) {
            resText.text = "=0"
            pointMode = false
            myExpr.clear()
        } else {
            myExpr.editAction(editTarget, "0", Keyboard.Action.DIGITAL)
            resText.text = "=" + myExpr.getResult().toString()
        }
    }

    function percentKeyHandler() {
        var newValue = (parseFloat(myExpr.getNameAsStr())/100).toString()
        if(editTarget < 0) {
            myExpr.editAction(0, newValue, Keyboard.Action.DIGITAL)
        } else {
            myExpr.editAction(editTarget, newValue, Keyboard.Action.DIGITAL)
        }
        resText.text = "=" + myExpr.getResult().toString()
    }
    function getChildren(i, j) {
        return keyboard.children[i*5 + j]
    }

    function changeMode() {
        if(advanced) {
            keyboard.height = 5*keyboard.width/4
            keyboard.y = root.height - keyboard.height
            var newWidth = parent.width/4
            var newHeight = parent.height/5
            for(var i=-2; i<5; i++) {
                getChildren(0, i+2).visible = false
                getChildren(1, i+2).visible = false
                for(var j=-1; j<4; j++) {
                    getChildren(i+2, j+1).setGeometry(j*newWidth, i*newWidth, newWidth, newWidth)
                }
            }
        } else {
            keyboard.height = 7*keyboard.width/5
            keyboard.y = root.height - keyboard.height
            newWidth = parent.width/5
            newHeight = parent.height/7
            for(i=0; i<7; i++) {
                getChildren(0, i).visible = true
                getChildren(1, i).visible = true
                for(j=0; j<5; j++) {
                    getChildren(i, j).setGeometry(j*newWidth, i*newWidth, newWidth, newWidth)
                }
            }
        }
        advanced = !advanced
    }

    property var changeActionState: function () {
        keyboard.keyDivision.changeState()
        keyboard.keyMult.changeState()
        keyboard.keyMinus.changeState()
        keyboard.keyPlus.changeState()
    }
    property var changeDigitalState: function () {
        for(var i=0; i<10; i++) {
            keyboard["key" + i.toString()].changeState()
        }
        keyboard.keyC.changeState()
        keyboard.keyDel.changeState()
        keyboard.keyPercent.changeState()
        keyboard.keyPoint.changeState()
    }
    Component.onCompleted: {
        console.log("Completed")
        var newWidth = parent.width/4
        var newHeight = parent.height/5
        for(var i=-2; i<5; i++) {
            for(var j=-1; j<4; j++) {
                getChildren(i+2, j+1).x = j * newWidth
                getChildren(i+2, j+1).y = i * newWidth
            }
        }
    }

    children: [
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "2nd";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "deg";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "sin";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "cos";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "tan";
            visible: false
        },
        //------------------------------------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "x^y";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "lg";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "ln";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "(";
            visible: false
        },
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: ")";
            visible: false
        },
        //------------------------------------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "sqrt";
        },
        CalcButton {
            id: key_C
            x: 0;   y: 0
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "C";
            onClicked: cKeyHandler()
        },
        CalcButton {
            id: key_DEL
            x: parent.width/4;   y: 0
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("<-")
            onClicked: delKeyHandler()
        },
        CalcButton {
            id: key_PERCENT
            x: parent.width/2;   y: 0
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("%")
            onClicked: percentKeyHandler()
        },
        CalcButton {
            id: key_DIVISION
            property int keyAction: Keyboard.Action.DIVISION
            x: 3*parent.width/4;   y: 0
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("÷")
            onClicked: actionKeyHandler(this)
        },
        //------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "X!";
        },
        CalcButton {
            id: key_7
            x: 0;   y: parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("7")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_8
            x: parent.width/4;   y: parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("8")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_9
            x: parent.width/2;   y: parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("9")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_MULT
            property int keyAction: Keyboard.Action.MULT
            x: 3*parent.width/4;   y: parent.height/5
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("*")
            onClicked: actionKeyHandler(this)
        },
        //------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "1/x";
        },
        CalcButton {
            id: key_4
            x: 0;   y: 2*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("4")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_5
            x: parent.width/4;   y: 2*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("5")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_6
            x: parent.width/2;   y: 2*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("6")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_MINUS
            property int keyAction: Keyboard.Action.MINUS
            x: 3*parent.width/4;   y: 2*parent.height/5
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("-")
            onClicked: actionKeyHandler(this)
        },
        //------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "PI";
        },
        CalcButton {
            id: key_1
            x: 0;   y: 3*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("1")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_2
            x: parent.width/4;   y: 3*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("2")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_3
            x: parent.width/2;   y: 3*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("3")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_PLUS
            property int keyAction: Keyboard.Action.PLUS
            x: 3*parent.width/4;   y: 3*parent.height/5
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("+")
            onClicked: actionKeyHandler(this)
        },
        //------------------
        CalcButton {
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: "e";
        },
        CalcButton {
            id: key_CHMODE
            x: 0;   y: 4*parent.height/5
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr("< >")
            onClicked: {
                changeMode()
                releaseHandler()
            }
        },
        CalcButton {
            id: key_0
            x: parent.width/4;   y: 4*parent.height/5
            imageSource: "img/logs_light.png"
            textColor: "#e2d4c0"
            mytext: qsTr("0")
            onClicked: {
                degitKeyHandler(mytext)
            }
        },
        CalcButton {
            id: key_POINT
            x: parent.width/2;   y: 4*parent.height/5
            imageSource: "img/Log2.png"
            textColor: "#d4bfa0"
            mytext: qsTr(".")
            onClicked: degitKeyHandler(mytext)
        },
        CalcButton {
            id: key_RESULT
            x: 3*parent.width/4;   y: 4*parent.height/5
            imageSource: "img/logs_top.png"
            textColor: "#e2d4c0"
            mytext: qsTr("=")
            onClicked: resKeyHandler()
        }
    ]
    property var keyDel: key_DEL
    property var keyC: key_C
    property var keyPercent: key_PERCENT
    property var keyDivision: key_DIVISION
    property var key7: key_7
    property var key8: key_8
    property var key9: key_9
    property var keyMult: key_MULT
    property var key4: key_4
    property var key5: key_5
    property var key6: key_6
    property var keyMinus: key_MINUS
    property var key1: key_1
    property var key2: key_2
    property var key3: key_3
    property var keyPlus: key_PLUS
    property var keyChmode: key_CHMODE
    property var key0: key_0
    property var keyPoint: key_POINT
    property var keyResult: key_RESULT
}

