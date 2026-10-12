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
    top: UiState.effectivePanelTopMargin
    right: UiState.panelRightMargin
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
    color: ThemeState.background
    border.color: "#706575"
    border.width: 1

    Column {
      anchors.fill: parent
      anchors.margins: 16
      spacing: 2

      Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        Text {
          text: "["
          color: ThemeState.muted
          font.family: "GeistMono Nerd Font"
          font.pixelSize: 12
          anchors.verticalCenter: parent.verticalCenter
        }

        PhantomButton {
          text: "C"
          selected: UiState.panelMode === "clock"
          onClicked: UiState.showClockMode()
        }

        Text {
          text: "|"
          color: ThemeState.muted
          font.family: "GeistMono Nerd Font"
          font.pixelSize: 12
          anchors.verticalCenter: parent.verticalCenter
        }

        PhantomButton {
          text: "T"
          selected: UiState.panelMode === "timer"
          onClicked: UiState.showTimerMode()
        }

        Text {
          text: "]"
          color: ThemeState.muted
          font.family: "GeistMono Nerd Font"
          font.pixelSize: 12
          anchors.verticalCenter: parent.verticalCenter
        }
      }

      Item {
        width: parent.width
        height: parent.height - 28

        Item {
          anchors.fill: parent
          visible: UiState.panelMode === "clock"

          ASCIIclock {
              anchors.centerIn: parent
              anchors.verticalCenterOffset: -18

              width: Math.min(parent.width, parent.height)
              height: width
              expanded: true
          }

          TimerProgress {
              anchors.centerIn: parent
              anchors.verticalCenterOffset: -18

              width: Math.min(parent.width, parent.height)
              height: width
          }
        }

        TimerControls {
          anchors.centerIn: parent
          visible: UiState.panelMode === "timer"
        }
      }
    }
  }
}
