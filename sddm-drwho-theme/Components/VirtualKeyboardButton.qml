import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: virtualKeyboardButtonRoot

  property int fontPointSize: 12
  property string fontFamily: ""

  property var virtualKeyboardRef: null

  readonly property color textColor: config.stringValue("VirtualKeyboardButtonTextColor")
  readonly property color hoverTextColor: config.stringValue("HoverVirtualKeyboardButtonTextColor")
  readonly property bool hidden: config.boolValue("HideVirtualKeyboard")
  readonly property bool keyboardVisible: virtualKeyboardRef && virtualKeyboardRef.state === "visible"

  Button {
    id: virtualKeyboardButton
    anchors.horizontalCenter: parent.horizontalCenter
    z: 1
    visible: virtualKeyboardRef && virtualKeyboardRef.status == Loader.Ready && !virtualKeyboardButtonRoot.hidden
    focusPolicy: Qt.NoFocus
    onClicked: virtualKeyboardRef.switchState()
    Keys.onReturnPressed: virtualKeyboardRef.switchState()
    Keys.onEnterPressed: virtualKeyboardRef.switchState()
    contentItem: Text {
      id: virtualKeyboardButtonText
      text: config.TranslateVirtualKeyboardButtonOff || "virtual keyboard (off)"
      font.pointSize: virtualKeyboardButtonRoot.fontPointSize * 0.8
      font.family: virtualKeyboardButtonRoot.fontFamily
      color: parent.visualFocus ? virtualKeyboardButtonRoot.hoverTextColor : virtualKeyboardButtonRoot.textColor
    }
    background: Rectangle {
      color: "transparent"
    }
    states: [
      State {
        name: "HoveredAndCheck"
        when: virtualKeyboardButtonRoot.keyboardVisible && virtualKeyboardButton.hovered
        PropertyChanges {
          target: virtualKeyboardButtonText
          text: config.TranslateVirtualKeyboardButtonOn || "virtual keyboard (on)"
          color: virtualKeyboardButtonRoot.hoverTextColor
        }
      },
      State {
        name: "checked"
        when: virtualKeyboardButtonRoot.keyboardVisible
        PropertyChanges {
          target: virtualKeyboardButtonText
          text: config.TranslateVirtualKeyboardButtonOn || "virtual keyboard (on)"
        }
      },
      State {
        name: "hovered"
        when: virtualKeyboardButton.hovered
        PropertyChanges {
          target: virtualKeyboardButtonText
          text: config.TranslateVirtualKeyboardButtonOff || "virtual keyboard (off)"
          color: virtualKeyboardButtonRoot.hoverTextColor
        }
      }
    ]
  }
}
