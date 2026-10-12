import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../components"
import "../state"

PanelWindow {
  id: root

  visible: UiState.panelVisible

  anchors {
    top: true
    right: true
  }

  margins {
    top: UiState.barVisible
    ? UiState.barHeight + 12
    : 12
    right: 5
  }

  implicitWidth: UiState.panelWidth
  implicitHeight: UiState.panelHeight

  color: "transparent"
  focusable: false
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.layer: WlrLayer.Overlay

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: "#F217151B"
    border.color: "#706575"
    border.width: 1

    Item {
      anchors.centerIn: parent

      width: Math.min(parent.width, parent.height) - 24
      height: width

      ASCIIclock {
        anchors.fill: parent
        expanded: true
      }

      TimerProgress {
        anchors.fill: parent
      }
    }
  }
}
