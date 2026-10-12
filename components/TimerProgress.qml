import QtQuick
import "../state"

Item {
  id: root

  readonly property int glyphCount: 120
  readonly property real ringRadius: Math.min(width, height) * 0.46
  property real fadeFraction: 0.02
  property real maximumOpacity: 0.9
  property real minimumOpacity: 0.1

  Canvas {
    id: canvas
    anchors.fill: parent
    renderTarget: Canvas.Image
    antialiasing: true

    onPaint: {
      const ctx = getContext("2d")
      ctx.reset()

      if (TimerState.durationMs <= 0)
      return

      const cx = width / 2
      const cy = height / 2

      const remainingFraction = Math.max(
        0, Math.min(1, 1 - TimerState.progress)
      )

      const remainingGlyphs = Math.ceil(
        root.glyphCount * remainingFraction
      )

      ctx.font = "9px monospace"
      ctx.textAlign = "center"
      ctx.textBaseline = "middle"
      ctx.fillStyle = "#C6A56B"

      for (let i = 0; i < remainingGlyphs; i++) {
        const angle =
        TimerState.startAngle
        + i * 2 * Math.PI / root.glyphCount

        const x = cx + Math.sin(angle) * root.ringRadius
        const y = cy - Math.cos(angle) * root.ringRadius

        const position = (i + 1) / remainingGlyphs

        const fadePosition = Math.max(
            0,
            (position - (1 - root.fadeFraction)) / root.fadeFraction
        )

        const smoothFade = fadePosition * fadePosition
            * (3 - 2 * fadePosition)

        ctx.globalAlpha = root.maximumOpacity
            - (root.maximumOpacity - root.minimumOpacity) * smoothFade
        ctx.fillText("·", x, y)
      }
    }
  }

  Connections {
    target: TimerState

    function onProgressChanged() {
      canvas.requestPaint()
    }

    function onStartAngleChanged() {
      canvas.requestPaint()
    }

    function onDurationMsChanged() {
      canvas.requestPaint()
    }
  }

  onWidthChanged: canvas.requestPaint()
  onHeightChanged: canvas.requestPaint()
}
