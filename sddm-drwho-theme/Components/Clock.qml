import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
  id: clock

  property int fontPointSize: config.intValue("FontSize") || 12

  width: parent.width / 2
  height: clockColumn.implicitHeight
  color: "transparent"

  readonly property string headerTextColor: config.stringValue("HeaderTextColor")
  readonly property string headerText: config.stringValue("HeaderText")
  readonly property string timeTextColor: config.stringValue("TimeTextColor")
  readonly property string dateTextColor: config.stringValue("DateTextColor")
  readonly property string locale: config.stringValue("Locale")

  readonly property var timeFormat: getLocaleData("HourFormat")
  readonly property var dateFormat: getLocaleData("DateFormat")
  readonly property bool debug: config.boolValue("DebugAll") || config.boolValue("DebugClock")

  border.width: debug ? 1 : 0
  border.color: debug ? "#ff4488" : "transparent"

  function getLocaleData(key) {
    var v = config.stringValue(key)
    if (v === undefined || v === "" || v === "short") return Locale.ShortFormat
    if (v === "long") return Locale.LongFormat
    if (v === "narrow") return Locale.NarrowFormat
    return v
  }

  Column {
    id: clockColumn
    width: parent.width
    spacing: 0

    Label {
      id: headerTextLabel
      anchors.horizontalCenter: parent.horizontalCenter
      font.pointSize: clock.fontPointSize * 3
      color: clock.headerTextColor
      renderType: Text.QtRendering
      text: clock.headerText
    }

    Label {
      id: timeLabel
      anchors.horizontalCenter: parent.horizontalCenter
      font.pointSize: clock.fontPointSize * 5
      font.bold: true
      color: clock.timeTextColor
      renderType: Text.QtRendering

      function updateTime() {
        text = new Date().toLocaleTimeString(Qt.locale(clock.locale), clock.timeFormat)
      }
    }

    Label {
      id: dateLabel
      anchors.horizontalCenter: parent.horizontalCenter
      color: clock.dateTextColor
      font.pointSize: clock.fontPointSize * 2
      font.bold: true
      renderType: Text.QtRendering

      function updateTime() {
        text = new Date().toLocaleDateString(Qt.locale(clock.locale), clock.dateFormat)
      }
    }

    Timer {
      interval: 1000
      repeat: true
      running: true
      onTriggered: {
        dateLabel.updateTime()
        timeLabel.updateTime()
      }
    }

    Component.onCompleted: {
      dateLabel.updateTime()
      timeLabel.updateTime()
    }
  }
}
