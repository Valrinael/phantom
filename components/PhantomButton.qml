import QtQuick
import QtQuick.Controls
import "../state"

Button {
  id: root

  property bool selected: false

  implicitWidth: Math.max(34, contentItem.implicitWidth + 16)
  implicitHeight: 26

  font.family: "GeistMono Nerd Font"
  font.pixelSize: 11

  contentItem: Text {
    text: root.text
    font: root.font
    color: !root.enabled
    ? ThemeState.muted
    : root.selected
    ? ThemeState.accent
    : root.hovered
    ? ThemeState.foreground
    : ThemeState.muted

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  background: Rectangle {
    radius: 4

    color: root.down
    ? Qt.rgba(1, 1, 1, 0.07)
    : root.hovered
    ? Qt.rgba(1, 1, 1, 0.035)
    : "transparent"

    border.width: root.selected ? 1 : 0
    border.color: ThemeState.muted
  }
}
