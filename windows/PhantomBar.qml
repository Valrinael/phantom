import QtQuick
import Quickshell
import Quickshell.Wayland
import "../state"

PanelWindow {
  id: root

  visible: UiState.barVisible

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: UiState.barHeight

  color: "transparent"
  focusable: false

  WlrLayershell.layer: WlrLayer.Top

  // Initially overlay other windows.
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    anchors.fill: parent
    color: "#F217151B"

    Rectangle {
      anchors.bottom: parent.bottom
      width: parent.width
      height: 0
      color: "#706575"
    }

    Text {
      anchors.centerIn: parent
      text: "PHANTOM"
      color: "#C6A56B"
      font.family: "GeistMono Nerd Font"
      font.pixelSize: 11
    }
  }
}
