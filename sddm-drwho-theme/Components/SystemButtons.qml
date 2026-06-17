import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import SddmComponents 2.0 as SDDM

RowLayout {
    id: systemButtonsRow

    property int fontPointSize: 12
    property ComboBox exposedSession

    readonly property var firstButton: systemButtons.itemAt(0)

    readonly property color iconColor: config.stringValue("SystemButtonsIconsColor")
    readonly property color hoverIconColor: config.stringValue("HoverSystemButtonsIconsColor")
    readonly property bool hidden: config.boolValue("HideSystemButtons")
    readonly property bool bypassChecks: config.boolValue("BypassSystemButtonsChecks")

    SDDM.TextConstants { id: textConstants }

    spacing: fontPointSize
    property var shutdown: ["Shutdown", config.TranslateShutdown || textConstants.shutdown, sddm.canPowerOff]
    property var reboot: ["Reboot", config.TranslateReboot || textConstants.reboot, sddm.canReboot]
    property var suspend: ["Suspend", config.TranslateSuspend || textConstants.suspend, sddm.canSuspend]
    property var hibernate: ["Hibernate", config.TranslateHibernate || textConstants.hibernate, sddm.canHibernate]

    Repeater {
        id: systemButtons
        model: [shutdown, reboot, suspend, hibernate]
        RoundButton {
            id: systemButton
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.topMargin: systemButtonsRow.fontPointSize * 6.5
            text: modelData[1]
            font.pointSize: systemButtonsRow.fontPointSize * 0.8
            icon.source: modelData ? Qt.resolvedUrl("../Assets/" + modelData[0] + ".svg") : ""
            icon.height: 2 * Math.round((systemButtonsRow.fontPointSize * 3) / 2)
            icon.width: 2 * Math.round((systemButtonsRow.fontPointSize * 3) / 2)
            icon.color: systemButtonsRow.iconColor
            palette.buttonText: systemButtonsRow.iconColor
            display: AbstractButton.TextUnderIcon
            visible: !systemButtonsRow.hidden && (systemButtonsRow.bypassChecks || modelData[2])
            hoverEnabled: true
            background: Rectangle {
                height: 2
                width: parent.width
                color: "transparent"
            }
            Keys.onReturnPressed: clicked()
            onClicked: {
                systemButtonsRow.forceActiveFocus();
                index == 0 ? sddm.powerOff() : index == 1 ? sddm.reboot() : index == 2 ? sddm.suspend() : sddm.hibernate();
            }
            KeyNavigation.left: index > 0 ? systemButtons.itemAt(index - 1) : null
            states: [
                State {
                    name: "pressed"
                    when: systemButton.down
                    PropertyChanges {
                        target: systemButton
                        icon.color: systemButtonsRow.hoverIconColor
                        palette.buttonText: Qt.darker(systemButtonsRow.hoverIconColor, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: systemButton.hovered
                    PropertyChanges {
                        target: systemButton
                        icon.color: systemButtonsRow.hoverIconColor
                        palette.buttonText: Qt.lighter(systemButtonsRow.hoverIconColor, 1.1)
                    }
                },
                State {
                    name: "focused"
                    when: systemButton.activeFocus
                    PropertyChanges {
                        target: systemButton
                        icon.color: systemButtonsRow.hoverIconColor
                        palette.buttonText: systemButtonsRow.hoverIconColor
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "icon.color, palette.buttonText"
                        duration: 150
                    }
                }
            ]
        }
    }
}
