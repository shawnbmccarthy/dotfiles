import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

Column {
  id: inputContainer
  Layout.fillWidth: true

  property var sessionSelect: null
  property ComboBox exposeSession: sessionSelect ? sessionSelect.exposeSession : null
  property bool failed

  property int fontPointSize: 12
  property string fontFamily: ""
  property int screenPadding: 0
  property bool rightToLeft: false
  property var keyNavDownTarget: null

  readonly property bool allowUppercaseUsernames: config.boolValue("AllowUppercaseLettersInUsernames")
  readonly property color warningColor: config.stringValue("WarningColor")
  readonly property color dropdownTextColor: config.stringValue("DropdownTextColor")
  readonly property color dropdownSelectedBg: config.stringValue("DropdownSelectedBackgroundColor")
  readonly property color dropdownBg: config.stringValue("DropdownBackgroundColor")
  readonly property color userIconColor: config.stringValue("UserIconColor")
  readonly property color hoverUserIconColor: config.stringValue("HoverUserIconColor")
  readonly property color loginFieldTextColor: config.stringValue("LoginFieldTextColor")
  readonly property color loginFieldBgColor: config.stringValue("LoginFieldBackgroundColor")
  readonly property color placeholderTextColor: config.stringValue("PlaceholderTextColor")
  readonly property color highlightBorderColor: config.stringValue("HighlightBorderColor")
  readonly property color passwordIconColor: config.stringValue("PasswordIconColor")
  readonly property color hoverPasswordIconColor: config.stringValue("HoverPasswordIconColor")
  readonly property color passwordFieldTextColor: config.stringValue("PasswordFieldTextColor")
  readonly property color passwordFieldBgColor: config.stringValue("PasswordFieldBackgroundColor")
  readonly property color loginButtonTextColor: config.stringValue("LoginButtonTextColor")
  readonly property color loginButtonBgColor: config.stringValue("LoginButtonBackgroundColor")
  readonly property int roundCorners: config.intValue("RoundCorners")
  readonly property bool forceLastUser: config.boolValue("ForceLastUser")
  readonly property bool passwordFocus: config.boolValue("PasswordFocus")
  readonly property bool hideCompletePassword: config.boolValue("HideCompletePassword")
  readonly property bool hideLoginButton: config.boolValue("HideLoginButton")
  readonly property bool allowEmptyPassword: config.boolValue("AllowEmptyPassword")

  SDDM.TextConstants { id: textConstants }

  function submitLogin() {
    var name = username.text
    if (!allowUppercaseUsernames)
      name = name.toLowerCase()
    sddm.login(name, password.text, sessionSelect.selectedSession)
  }

  function focusActiveInput() {
    if (passwordFocus || password.visible)
      password.forceActiveFocus()
    else
      username.forceActiveFocus()
  }

  Item {
    id: errorMessageField
    height: inputContainer.fontPointSize * 2
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      id: errorMessage
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
      font.pointSize: inputContainer.fontPointSize * 0.8
      font.italic: true
      color: inputContainer.warningColor
      opacity: 0

      states: [
        State {
          name: "fail"
          when: failed
          PropertyChanges {
            target: errorMessage
            opacity: 1
          }
        },
        State {
          name: "capslock"
          when: keyboard.capsLock
          PropertyChanges {
            target: errorMessage
            opacity: 1
          }
        }
      ]
      transitions: [
        Transition {
          PropertyAnimation {
            properties: "opacity"
            duration: 100
          }
        }
      ]
    }
  }
  Item {
    id: usernameField

    height: inputContainer.fontPointSize * 4.5
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    ComboBox {
      id: selectUser

      width: parent.height
      height: parent.height
      anchors.left: parent.left
      z: 2

      model: userModel
      currentIndex: model.lastIndex
      textRole: "name"
      hoverEnabled: true
      onActivated: {
        username.text = currentText
      }

      property var popkey: inputContainer.rightToLeft ? Qt.Key_Right : Qt.Key_Left
      Keys.onPressed: function(event) {
        if (event.key == Qt.Key_Down && !popup.opened)
          username.forceActiveFocus();
        if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
          popup.open();
      }
      KeyNavigation.down: username
      KeyNavigation.right: username

      delegate: ItemDelegate {
        width: popupHandler.width - 20
        anchors.horizontalCenter: popupHandler.horizontalCenter

        contentItem: Text {
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter

          text: model.name
          font.pointSize: inputContainer.fontPointSize * 0.8
          font.capitalization: Font.AllLowercase
          font.family: inputContainer.fontFamily
          color: inputContainer.dropdownTextColor
        }

        background: Rectangle {
          color: selectUser.highlightedIndex === index ? inputContainer.dropdownSelectedBg : "transparent"
        }
      }

      indicator: Button {
        id: usernameIcon

        width: selectUser.height * 1
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: selectUser.height * 0

        icon.height: parent.height * 0.25
        icon.width: parent.height * 0.25
        enabled: false
        icon.color: inputContainer.userIconColor
        icon.source: Qt.resolvedUrl("../Assets/User.svg")

        background: Rectangle {
          color: "transparent"
          border.color: "transparent"
        }
      }

      background: Rectangle {
        color: "transparent"
        border.color: "transparent"
      }

      popup: Popup {
        id: popupHandler

        implicitHeight: contentItem.implicitHeight
        width: usernameField.width
        y: parent.height - username.height / 3
        x: inputContainer.rightToLeft ? -loginButton.width + selectUser.width : 0
        rightMargin: inputContainer.rightToLeft ? inputContainer.screenPadding + usernameField.width / 2 : undefined
        padding: 10

        contentItem: ListView {
          implicitHeight: contentHeight + 20

          clip: true
          model: selectUser.popup.visible ? selectUser.delegateModel : null
          currentIndex: selectUser.highlightedIndex
          ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
          radius: inputContainer.roundCorners / 2
          color: inputContainer.dropdownBg
          layer.enabled: true
        }

        enter: Transition {
          NumberAnimation { property: "opacity"; from: 0; to: 1 }
        }
      }

      states: [
        State {
          name: "pressed"
          when: selectUser.down
          PropertyChanges {
            target: usernameIcon
            icon.color: Qt.lighter(inputContainer.hoverUserIconColor, 1.1)
          }
        },
        State {
          name: "hovered"
          when: selectUser.hovered
          PropertyChanges {
            target: usernameIcon
            icon.color: Qt.lighter(inputContainer.hoverUserIconColor, 1.2)
          }
        },
        State {
          name: "focused"
          when: selectUser.activeFocus
          PropertyChanges {
            target: usernameIcon
            icon.color: inputContainer.hoverUserIconColor
          }
        }
      ]
      transitions: [
        Transition {
          PropertyAnimation {
            properties: "color, border.color, icon.color"
            duration: 150
          }
        }
      ]

    }

    TextField {
      id: username

      anchors.centerIn: parent
      height: inputContainer.fontPointSize * 3
      width: parent.width
      horizontalAlignment: TextInput.AlignHCenter
      z: 1

      text: inputContainer.forceLastUser ? selectUser.currentText : null
      color: inputContainer.loginFieldTextColor
      font.bold: true
      font.capitalization: inputContainer.allowUppercaseUsernames ? Font.MixedCase : Font.AllLowercase
      placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
      placeholderTextColor: inputContainer.placeholderTextColor
      selectByMouse: true
      renderType: Text.QtRendering

      onFocusChanged: {
        if (focus)
          selectAll()
      }

      background: Rectangle {
        color: inputContainer.loginFieldBgColor
        opacity: 0.2
        border.color: "transparent"
        border.width: parent.activeFocus ? 2 : 1
        radius: inputContainer.roundCorners || 0
      }

      onAccepted: submitLogin()
      KeyNavigation.down: passwordIcon

      states: [
        State {
          name: "focused"
          when: username.activeFocus
          PropertyChanges {
            target: username.background
            border.color: inputContainer.highlightBorderColor
          }
          PropertyChanges {
            target: username
            color: Qt.lighter(inputContainer.loginFieldTextColor, 1.15)
          }
        }
      ]
    }
  }
  Item {
    id: passwordField
    height: inputContainer.fontPointSize * 4.5
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
      id: passwordIcon

      height: parent.height
      width: selectUser.height * 1
      anchors.left: parent.left
      anchors.leftMargin: selectUser.height * 0
      anchors.verticalCenter: parent.verticalCenter
      z: 2

      icon.height: parent.height * 0.25
      icon.width: parent.height * 0.25
      icon.color: inputContainer.passwordIconColor
      icon.source: Qt.resolvedUrl("../Assets/Password2.svg")

      background: Rectangle {
        color: "transparent"
        border.color: "transparent"
      }

      states: [
        State {
          name: "visiblePasswordFocused"
          when: passwordIcon.checked && passwordIcon.activeFocus
          PropertyChanges {
            target: passwordIcon
            icon.source: Qt.resolvedUrl("../Assets/Password.svg")
            icon.color: inputContainer.hoverPasswordIconColor
          }
        },
        State {
          name: "visiblePasswordHovered"
          when: passwordIcon.checked && passwordIcon.hovered
          PropertyChanges {
            target: passwordIcon
            icon.source: Qt.resolvedUrl("../Assets/Password.svg")
            icon.color: inputContainer.hoverPasswordIconColor
          }
        },
        State {
          name: "visiblePassword"
          when: passwordIcon.checked
          PropertyChanges {
            target: passwordIcon
            icon.source: Qt.resolvedUrl("../Assets/Password.svg")
          }
        },
        State {
          name: "hiddenPasswordFocused"
          when: passwordIcon.enabled && passwordIcon.activeFocus
          PropertyChanges {
            target: passwordIcon
            icon.source: Qt.resolvedUrl("../Assets/Password2.svg")
            icon.color: inputContainer.hoverPasswordIconColor
          }
        },
        State {
          name: "hiddenPasswordHovered"
          when: passwordIcon.hovered
          PropertyChanges {
            target: passwordIcon
            icon.source: Qt.resolvedUrl("../Assets/Password2.svg")
            icon.color: inputContainer.hoverPasswordIconColor
          }
        }
      ]

      onClicked: toggle()
      Keys.onReturnPressed: toggle()
      Keys.onEnterPressed: toggle()
      KeyNavigation.down: password

    }

    TextField {
      id: password

      height: inputContainer.fontPointSize * 3
      width: parent.width
      anchors.centerIn: parent
      horizontalAlignment: TextInput.AlignHCenter

      font.bold: true
      color: inputContainer.passwordFieldTextColor
      focus: inputContainer.passwordFocus
      echoMode: passwordIcon.checked ? TextInput.Normal : TextInput.Password
      placeholderText: config.TranslatePlaceholderPassword || textConstants.password
      placeholderTextColor: inputContainer.placeholderTextColor
      passwordCharacter: "•"
      passwordMaskDelay: inputContainer.hideCompletePassword ? undefined : 1000
      renderType: Text.QtRendering
      selectByMouse: true

      background: Rectangle {
        color: inputContainer.passwordFieldBgColor
        opacity: 0.2
        border.color: "transparent"
        border.width: parent.activeFocus ? 2 : 1
        radius: inputContainer.roundCorners || 0
      }
      onAccepted: submitLogin()
      KeyNavigation.down: loginButton
    }

    states: [
      State {
        name: "focused"
        when: password.activeFocus
        PropertyChanges {
          target: password.background
          border.color: inputContainer.highlightBorderColor
        }
        PropertyChanges {
          target: password
          color: Qt.lighter(inputContainer.loginFieldTextColor, 1.15)
        }
      }
    ]
    transitions: [
      Transition {
        PropertyAnimation {
          properties: "color, border.color"
          duration: 150
        }
      }
    ]
  }
  Item {
    id: login
    height: inputContainer.fontPointSize * 9
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    visible: !inputContainer.hideLoginButton

    Button {
      id: loginButton

      height: inputContainer.fontPointSize * 3
      implicitWidth: parent.width
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter

      text: config.TranslateLogin || textConstants.login
      enabled: inputContainer.allowEmptyPassword || (username.text !== "" && password.text !== "")
      hoverEnabled: true

      contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.bold: true
        font.pointSize: inputContainer.fontPointSize
        font.family: inputContainer.fontFamily
        color: inputContainer.loginButtonTextColor
        text: parent.text
        opacity: 0.5
      }

      background: Rectangle {
        id: buttonBackground

        color: inputContainer.loginButtonBgColor
        opacity: 0.2
        radius: inputContainer.roundCorners || 0
      }

      states: [
        State {
          name: "pressed"
          when: loginButton.down
          PropertyChanges {
            target: buttonBackground
            color: Qt.darker(inputContainer.loginButtonBgColor, 1.1)
            opacity: 1
          }
          PropertyChanges {
            target: loginButton.contentItem
          }
        },
        State {
          name: "hovered"
          when: loginButton.hovered
          PropertyChanges {
            target: buttonBackground
            color: Qt.lighter(inputContainer.loginButtonBgColor, 1.15)
            opacity: 1
          }
          PropertyChanges {
            target: loginButton.contentItem
            opacity: 1
          }
        },
        State {
          name: "focused"
          when: loginButton.activeFocus
          PropertyChanges {
            target: buttonBackground
            color: Qt.lighter(inputContainer.loginButtonBgColor, 1.2)
            opacity: 1
          }
          PropertyChanges {
            target: loginButton.contentItem
            opacity: 1
          }
        },
        State {
          name: "enabled"
          when: loginButton.enabled
          PropertyChanges {
            target: buttonBackground
            color: inputContainer.loginButtonBgColor
            opacity: 1
          }
          PropertyChanges {
            target: loginButton.contentItem
            opacity: 1
          }
        }
      ]
      transitions: [
        Transition {
          PropertyAnimation {
            properties: "opacity, color"
            duration: 300
          }
        }
      ]

      onClicked: submitLogin()
      Keys.onReturnPressed: clicked()
      Keys.onEnterPressed: clicked()

      KeyNavigation.down: inputContainer.keyNavDownTarget
    }
  }
  Connections {
    target: sddm
    function onLoginSucceeded() {}
    function onLoginFailed() {
      failed = true
      resetError.running ? resetError.stop() && resetError.start() : resetError.start()
    }
  }
  Timer {
    id: resetError
    interval: 2000
    onTriggered: failed = false
    running: false
  }
}
