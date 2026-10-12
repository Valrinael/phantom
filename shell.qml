import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "components"
import "state"
import "windows"

Scope {
  id: root

  PanelWindow {
    id: clockWindow
    visible: UiState.clockVisible && !UiState.panelVisible

    IpcHandler {
      target: "clock"

      function timerStart(seconds: int): void {
        TimerState.start(seconds)
      }

      function timerPause(): void {
        TimerState.pause()
      }

      function timerResume(): void {
        TimerState.resume()
      }

      function timerReset(): void {
        TimerState.reset()
      }

      function timerStatus(): string {
        return "running=" + TimerState.running
        + " paused=" + TimerState.paused
        + " remaining=" + TimerState.formattedRemaining
        + " progress=" + TimerState.progress
      }

      function toggle(): void {
          UiState.toggleClock()
      }

      function contrast(): void {
          UiState.toggleContrast()
      }

      function toggleBar(): void {
          UiState.toggleBar()
      }

      function togglePanel(): void {
          UiState.togglePanel()
      }

      function toggleTimerSubPanel(): void {
          UiState.toggleTimerSubPanel()
      }

      function timerMode(): void {
          UiState.showTimerMode()
      }

      function clockMode(): void {
          UiState.showClockMode()
      }
    }

    anchors {
      top: true
      right: true
    }

    margins {
      top: UiState.effectiveClockTopMargin
      right: 5
    }

    implicitWidth: 180
    implicitHeight: 180

    exclusionMode: ExclusionMode.Ignore
    focusable: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay

    // clock background config: change #XX<color> for opacity
    Rectangle {
      anchors.fill: parent
      radius: width / 2

    color: UiState.highContrast
        ? "#F217151B"
        : "#0017151B"

      Behavior on color {
        ColorAnimation {
          duration: 180
        }
      }

      ASCIIclock {
        anchors.fill: parent
      }

      TimerProgress {
        anchors.fill: parent
      }
    }
  }

  PhantomBar {}

  TimerPanel {}

  TimerSubPanel {}
}
