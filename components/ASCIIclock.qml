import QtQuick
import "../state"

Item {
  id: root

  // Visual settings
  property color dialColor: "#817486"
  property color markerColor: "#c6a56b"
  property color hourColor: "#d3bc93"
  property color minuteColor: "#c5b9ca"
  property color secondColor: "#9d7c87"

  property int glyphCount: 120
  property string fontFamily: "GeistMono Nerd Font"

  property var glyphStyles: ({
    dial: {
      char: "·",
      size: 7,
      offsetX: 0,
      offsetY: 2.4,
      color: "#706575"
    },

    marker: {
      char: "•",
      size: 9,
      offsetX: 0,
      offsetY: 3.0,
      color: "#b79b72"
    },

    cardinal: {
      char: "◆",
      size: 20,
      offsetX: 0,
      offsetY: 5.2,
      color: "#e8cfa3"
    },

    hour: {
      char: "'",
      size: 12,
      offsetX: 0,
      offsetY: 3.7,
      color: "#d9c8b1",
      spacing: 7,
      start: 10,
      length: 0.7,
      width: 2
      // rotationOffset: Math.PI / 6
    },

    minute: {
      char: "·",
      size: 18,
      offsetX: 0,
      offsetY: 2.7,
      color: "#e1d9dc",
      spacing: 5,
      start: 6,
      length: 0.8
    },

    second: {
      char: "·",
      size: 20,
      offsetX: 0,
      offsetY: 2.4,
      color: "#aa7889",
      spacing: 3,
      start: 6,
      length: 0.85
    },

    pivot: {
      char: "•",
      size: 9,
      offsetX: 0,
      offsetY: 3.0,
      color: "#e8cfa3"
    }
  })

  // Shared time state
  readonly property date now: TimeState.now

  Canvas {
    id: canvas
    anchors.fill: parent
    antialiasing: true
    renderTarget: Canvas.Image

    onPaint: {
      const ctx = getContext("2d")

      ctx.reset()

      const cx = width / 2
      const cy = height / 2
      const radius = Math.min(width, height) * 0.40

      // Helper: draw one character at a position.
      function glyph(styleName, x, y, rotation = 0) {
        const style = root.glyphStyles[styleName]

        ctx.save()
        ctx.translate(x, y)
        ctx.rotate(rotation)

        ctx.fillStyle = style.color
        ctx.font = `${style.size}px "${root.fontFamily}"`
        ctx.textAlign = "center"
        ctx.textBaseline = "alphabetic"

        ctx.shadowColor = "#d9000000"
        ctx.shadowBlur = 0
        ctx.shadowOffsetX = 0
        ctx.shadowOffsetY = 0
        ctx.shadowBlur =
        styleName === "hour" || styleName === "minute"
        ? 0
        : 0

        ctx.fillText(
          style.char,
          style.offsetX,
          style.offsetY
        )

        ctx.restore()
      }

      // Circular dial
      for (let i = 0; i < root.glyphCount; i++) {
        const angle = i * 2 * Math.PI / root.glyphCount

        const x = cx + Math.sin(angle) * radius
        const y = cy - Math.cos(angle) * radius

        const markerInterval = root.glyphCount / 12
        const hourIndex = Math.round(i / markerInterval)

        if (i % markerInterval === 0) {
          const cardinal = hourIndex % 3 === 0

          glyph(cardinal ? "cardinal" : "marker", x, y)
        } else {
          glyph("dial", x, y)
        }
      }

      // Helper: draw a hand from the center.
      function hand(angle, styleName) {
        const style = root.glyphStyles[styleName]

        const length = radius * style.length
        const spacing = style.spacing
        const start = style.start ?? spacing

        const trackWidth = style.width ?? 0

        const perpX = Math.cos(angle)
        const perpY = Math.sin(angle)

        for (let distance = start;
        distance <= length;
        distance += spacing) {

          const x = cx + Math.sin(angle) * distance
          const y = cy - Math.cos(angle) * distance

          if (trackWidth > 0) {
            glyph(
              styleName,
              x + perpX * trackWidth / 2,
              y + perpY * trackWidth / 2,
              angle
            )

            glyph(
              styleName,
              x - perpX * trackWidth / 2,
              y - perpY * trackWidth / 2,
              angle
            )
          } else {
            glyph(styleName, x, y, angle + (style.rotationOffset ?? 0))
          }
        }
      }

      const h = root.now.getHours() % 12
      const m = root.now.getMinutes()
      const s = root.now.getSeconds()

      const hourAngle =
      (h + m / 60) * Math.PI / 6

      const minuteAngle =
      (m + s / 60) * Math.PI / 30

      const secondAngle =
      s * Math.PI / 30

      // Draw hands from longest to shortest
      hand(secondAngle, "second")
      hand(minuteAngle, "minute")
      hand(hourAngle, "hour")

      // Draw pivot last
      glyph("pivot", cx, cy)
    }
  }

  Connections {
    target: TimeState

    function onNowChanged() {
      canvas.requestPaint()
    }
  }

  onWidthChanged: canvas.requestPaint()
  onHeightChanged: canvas.requestPaint()
}
