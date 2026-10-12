import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"
import "../state"

PanelWindow {
  id: root

  visible: UiState.panelVisible
  && UiState.timerSubPanelVisible

  anchors {
    top: true
    right: true
  }

  margins {
    top: UiState.effectivePanelTopMargin
    + UiState.panelHeight
    + UiState.panelGap
    right: UiState.panelRightMargin
  }

  implicitWidth: UiState.panelWidth
  implicitHeight: 180

  color: "transparent"
  focusable: false
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.layer: WlrLayer.Overlay

  Rectangle {
    anchors.fill: parent
    radius: 12
    color: ThemeState.background
    border.color: ThemeState.muted
    border.width: 1

    TimerControls {
      anchors.centerIn: parent
    }
  }
}
