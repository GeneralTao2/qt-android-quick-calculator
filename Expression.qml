import QtQuick 2.0

ListView {
    anchors.fill: parent
    orientation: Qt.Horizontal
    layoutDirection: Qt.RightToLeft
    property var clear: function() {
        myExpr.model.clear();
        myExpr.model.append({"name": "0", "bgColor": "lightgreen", "bgBorderColor": "lightgreen", "expression": Keyboard.Action.DIGITAL});
    }
    property var addToRight: function(name, action) {
        myExpr.model.insert(0, {"name": name, "bgColor": "lightgreen", "bgBorderColor": "lightgreen", "expression": action});
    }
    property var removeFromRight: function() {
        myExpr.model.remove(0)
    }
    property var editAction: function(index, name, action) {
        myExpr.model.set(index, {"name": name, "expression": action});
    }
    property var length: function() {
        return myExpr.model.count
    }
    property var getNameAsStr: function(index) {
        return myExpr.model.get(index).name
    }
    property var getNameAsDig: function(index) {
        return parseFloat(myExpr.model.get(index).name)
    }
    property var getAction: function(index) {
        return myExpr.model.get(index).expression
    }
    property var getResult: function() {
        var text = 0
        if(myExpr.model.count < 3) {
            text = parseFloat(myExpr.model.get(myExpr.model.count-1).name)
        } else {
            text = parseFloat(myExpr.model.get(myExpr.model.count-1).name)
            for(var j = myExpr.model.count-2; j>=0; j-=2) {
                if(j === 0 && myExpr.model.get(j).expression !== Keyboard.Action.DIGITAL) {
                    break
                }
                var nextValue = parseFloat(myExpr.model.get(j-1).name)
                switch(myExpr.model.get(j).expression) {
                case Keyboard.Action.NONE:
                    text = nextValue
                    break;
                case Keyboard.Action.PLUS:
                    text += nextValue
                    break;
                case Keyboard.Action.MINUS:
                    text -= nextValue
                    break;
                case Keyboard.Action.MULT:
                    text *= nextValue
                    break;
                case Keyboard.Action.DIVISION:
                    text /= nextValue
                    break;
                }
            }
        }
        return +text.toFixed(4)
    }
    property var getExpression: function() {
        var text = ""
        for(var i = myExpr.model.count - 1; i>=0; i--) {
            text += myExpr.model.get(i).name
        }
        return text
    }
    property var disableAction: function(index) {
        myExpr.model.setProperty(index, "bgColor", "lightgreen")
        myExpr.model.setProperty(index, "bgBorderColor", "lightgreen")
    }

    model: ListModel {
        Component.onCompleted: {
            myExpr.model.insert(0, {"name": "0", "bgColor": "lightgreen", "bgBorderColor": "lightgreen", "expression": Keyboard.Action.DIGITAL});
        }
    }
    delegate: ExpressionDelegate {
        name: model.name
        bgColor: model.bgColor
        bgBorderColor: model.bgBorderColor
        expression: model.expression
        MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(keyboard.editTarget >= 0) {
                        if( !( ( (myExpr.getAction(keyboard.editTarget) === Keyboard.Action.DIGITAL) &&
                               (myExpr.getAction(model.index) === Keyboard.Action.DIGITAL) ) ||
                             ( (myExpr.getAction(keyboard.editTarget) !== Keyboard.Action.DIGITAL) &&
                               (myExpr.getAction(model.index) !== Keyboard.Action.DIGITAL) ) ) ){
                            keyboard.changeActionState()
                            keyboard.changeDigitalState()
                        }
                    } else if(myExpr.getAction(model.index) === Keyboard.Action.DIGITAL) {
                        keyboard.changeActionState()
                    } else {
                        keyboard.changeDigitalState()
                    }
                    keyboard.keyResult.mytext = "✓"
                    keyboard.keyResult.textColor = "green"
                    keyboard.editTarget = model.index
                    keyboard.firstEdit = true

                    for(var i=0; i< myExpr.model.count; i++) {
                        myExpr.model.setProperty(i, "bgColor", "lightgreen")
                        myExpr.model.setProperty(i, "bgBorderColor", "lightgreen")
                     }
                    myExpr.model.setProperty(model.index, "bgColor", "lightblue")
                    myExpr.model.setProperty(model.index, "bgBorderColor", "blue")
                 }
            }

    }
}
