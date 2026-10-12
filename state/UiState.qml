pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  property string panelMode: "clock"
  property bool clockVisible: true
  property bool barVisible: false
  property bool panelVisible: false
  property bool highContrast: false

  // Layout dimensions, shared by all windows.
  property int barHeight: 26
  property int panelWidth: 420
  property int panelHeight: 460

  property int clockTopMargin: 30
  property int clockRightMargin: 5
  property int clockBarGap: 12

  property int panelRightMargin: 5
  property int panelTopMargin: 5
  property int panelGap: 8

  readonly property int effectivePanelTopMargin:
    panelTopMargin + (barVisible ? barHeight : 0)

  readonly property int effectiveClockTopMargin:
  clockTopMargin
  + (barVisible ? barHeight + clockBarGap : 0)

  function toggleClock() {
    clockVisible = !clockVisible
  }

  function toggleBar() {
    barVisible = !barVisible
  }

  function togglePanel() {
    panelVisible = !panelVisible
  }

  function toggleContrast() {
    highContrast = !highContrast
  }

  // Timer subpanel
  property bool timerSubPanelVisible: false

  function toggleTimerSubPanel() {
      timerSubPanelVisible = !timerSubPanelVisible
  }
  
  function showClockMode() {
      panelMode = "clock"
  }
  
  function showTimerMode() {
      panelMode = "timer"
  }
}
