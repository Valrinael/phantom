import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "components"
import "state"

PanelWindow {
  id: root
  property bool clockVisible: true
  property bool highContrast: false

  IpcHandler {
    target: "clock"

    function toggle(): void {
      root.clockVisible = !root.clockVisible
    }

    function contrast(): void {
      root.highContrast = !root.highContrast
    }

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
  }

  visible: clockVisible

  anchors {
    top: true
    right: true
  }

  margins {
    top: 30
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

    color: root.highContrast
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
