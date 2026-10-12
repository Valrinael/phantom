pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root
  property real startAngle: 0
  // --- Timer state ---

  property int durationMs: 0
  property int remainingMs: 0

  property bool running: false
  property bool paused: false

  // Absolute deadline while running.
  property double deadlineMs: 0

  // Progress: 0 = just started, 1 = complete.
  readonly property real progress:
  durationMs > 0
  ? Math.max(0, Math.min(1,
  1 - remainingMs / durationMs))
  : 0

  // Display-friendly remaining time.
  readonly property int remainingSeconds:
  Math.ceil(remainingMs / 1000)

  readonly property string formattedRemaining: {
    const total = remainingSeconds
    const hours = Math.floor(total / 3600)
    const minutes = Math.floor((total % 3600) / 60)
    const seconds = total % 60

    const mm = String(minutes).padStart(2, "0")
    const ss = String(seconds).padStart(2, "0")

    return hours > 0
    ? hours + ":" + mm + ":" + ss
    : mm + ":" + ss
  }

  signal finished()

  // --- Countdown update ---

  Timer {
    id: ticker
    interval: 100
    repeat: true
    running: root.running

    onTriggered: root.updateRemaining()
  }

  function updateRemaining() {
    if (!running)
    return

    remainingMs = Math.max(
      0,
      deadlineMs - Date.now()
    )

    if (remainingMs <= 0) {
      running = false
      paused = false
      finished()
    }
  }

  // --- Controls ---

  function start(seconds) {
    if (seconds <= 0)
    return

    durationMs = Math.round(seconds * 1000)
    remainingMs = durationMs

    const now = new Date()
    startAngle = (now.getMinutes() + now.getSeconds() / 60) * Math.PI / 30

    deadlineMs = Date.now() + durationMs

    paused = false
    running = true
  }

  function pause() {
    if (!running)
    return

    updateRemaining()

    running = false
    paused = remainingMs > 0
  }

  function resume() {
    if (!paused || remainingMs <= 0)
    return

    deadlineMs = Date.now() + remainingMs

    paused = false
    running = true
  }

  function reset() {
    running = false
    paused = false

    durationMs = 0
    remainingMs = 0
    deadlineMs = 0
  }
}
