import QtQuick 2.15
import QtQuick.Layouts 1.15
import SddmComponents 2.0 as SDDM

ColumnLayout {
  id: formContainer

  property real screenHeight: 0
  property int fontPointSize: 12
  property string fontFamily: ""
  property int screenPadding: 0
  property string formPosition: "center"
  property bool rightToLeft: false
  property var virtualKeyboardRef: null

  readonly property bool hideSystemButtons: config.boolValue("HideSystemButtons")

  function focusActiveInput() {
    input.focusActiveInput()
  }

  readonly property int formSideMargin: {
    if (screenPadding === 0)
      return 0
    if (formPosition === "left")
      return -screenPadding
    if (formPosition === "right")
      return screenPadding
    return 0
  }

  Clock {
    id: clock
    fontPointSize: formContainer.fontPointSize
    Layout.row: 0
    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
    Layout.preferredHeight: screenHeight / 3
    Layout.leftMargin: formSideMargin
  }

  SessionButton {
    id: sessionSelect
    fontPointSize: formContainer.fontPointSize
    fontFamily: formContainer.fontFamily
    Layout.row: 3
    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
    Layout.preferredHeight: screenHeight / 54
    Layout.maximumHeight: screenHeight / 54
    Layout.leftMargin: formSideMargin
  }

  Input {
    id: input
    fontPointSize: formContainer.fontPointSize
    fontFamily: formContainer.fontFamily
    screenPadding: formContainer.screenPadding
    rightToLeft: formContainer.rightToLeft
    keyNavDownTarget: hideSystemButtons ? virtualKeyboardRef : systemButtons.firstButton
    sessionSelect: sessionSelect
    Layout.row: 1
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: screenHeight / 10
    Layout.leftMargin: formSideMargin
    Layout.topMargin: 0
  }

  SystemButtons {
    id: systemButtons
    fontPointSize: formContainer.fontPointSize
    Layout.row: 2
    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
    Layout.preferredHeight: screenHeight / 5
    Layout.maximumHeight: screenHeight / 5
    Layout.leftMargin: formSideMargin
    exposedSession: input.exposeSession
  }

  VirtualKeyboardButton {
    id: virtualKeyboardButton
    fontPointSize: formContainer.fontPointSize
    fontFamily: formContainer.fontFamily
    virtualKeyboardRef: formContainer.virtualKeyboardRef
    Layout.row: 4
    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
    Layout.preferredHeight: screenHeight / 27
    Layout.maximumHeight: screenHeight / 27
    Layout.leftMargin: formSideMargin
  }
}
