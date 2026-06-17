import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
  id: sessionButton

  property int fontPointSize: 12
  property string fontFamily: ""
  property var selectedSession: selectSession.currentIndex
  property ComboBox exposeSession: selectSession

  readonly property color textColor: config.stringValue("SessionButtonTextColor")
  readonly property color hoverTextColor: config.stringValue("HoverSessionButtonTextColor")
  readonly property color dropdownTextColor: config.stringValue("DropdownTextColor")
  readonly property color dropdownSelectedBg: config.stringValue("DropdownSelectedBackgroundColor")
  readonly property color dropdownBg: config.stringValue("DropdownBackgroundColor")
  readonly property int roundCorners: config.intValue("RoundCorners")

  height: fontPointSize
  width: parent.width / 2

  ComboBox {
    id: selectSession
    height: sessionButton.fontPointSize * 2
    anchors.horizontalCenter: parent.horizontalCenter
    hoverEnabled: true
    model: sessionModel
    currentIndex: model.lastIndex
    textRole: "name"

    Keys.onPressed: function(event) {
      if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
        popup.open()
    }
    delegate: ItemDelegate {
      width: popupHandler.width - 20
      anchors.horizontalCenter: popupHandler.horizontalCenter
      contentItem: Text {
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: model.name
        font.pointSize: sessionButton.fontPointSize * 0.8
        font.family: sessionButton.fontFamily
        color: sessionButton.dropdownTextColor
      }
      background: Rectangle {
        color: selectSession.highlightedIndex === index ? sessionButton.dropdownSelectedBg : "transparent"
      }
    }
    indicator {
      visible: false
    }
    contentItem: Text {
      id: displayedItem
      verticalAlignment: Text.AlignVCenter
      text: (config.TranslateSessionSelection || "Session") + "(" + selectSession.currentText + ")"
      color: sessionButton.textColor
      font.pointSize: sessionButton.fontPointSize * 0.8
      font.family: sessionButton.fontFamily
      Keys.onReleased: parent.popup.open()
    }
    background: Rectangle {
      height: parent.visualFocus ? 2 : 0
      width: displayedItem.implicitWidth
      color: "transparent"
    }
    popup: Popup {
      id: popupHandler
      implicitHeight: contentItem.implicitHeight
      width: sessionButton.width
      y: parent.height - 1
      x: -popupHandler.width / 2 + displayedItem.width / 2
      padding: 10

      contentItem: ListView {
        implicitHeight: contentHeight + 20
        clip: true
        model: selectSession.popup.visible ? selectSession.delegateModel : null
        currentIndex: selectSession.highlightedIndex
        ScrollIndicator.vertical: ScrollIndicator {}
      }
      background: Rectangle {
        radius: sessionButton.roundCorners / 2
        color: sessionButton.dropdownBg
        layer.enabled: true
      }
      enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1 }
      }
    }
    states: [
      State {
        name: "pressed"
        when: selectSession.down
        PropertyChanges {
          target: displayedItem
          color: Qt.darker(sessionButton.hoverTextColor, 1.1)
        }
      },
      State {
        name: "hovered"
        when: selectSession.hovered
        PropertyChanges {
          target: displayedItem
          color: Qt.lighter(sessionButton.hoverTextColor, 1.1)
        }
      },
      State {
        name: "focused"
        when: selectSession.visualFocus
        PropertyChanges {
          target: displayedItem
          color: sessionButton.hoverTextColor
        }
      }
    ]
    transitions: [
      Transition {
        PropertyAnimation {
          properties: "color"
          duration: 150
        }
      }
    ]
  }
}
