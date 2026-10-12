import QtQuick
import "../state"

Item {
  id: root

  property bool expanded: false

  // Visual settings
  property bool showHourLines: true
  property real hourLineOpacity: 0.16
  property real hourLineStart: 0.76
  property real hourLineEnd: 0.93
  property real hourLineWidth: 0.7
  property color hourLineColor: "#B79B72"

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

  property var expandedGlyphStyles: ({
    dial: {
      char: "·",
      size: 9,
      offsetX: 0,
      offsetY: 3,
      color: "#817486"
    },

    halfSecond: {
      char: "·",
      size: 6,
      offsetX: 0,
      offsetY: 2,
      color: "#514A58"
    },

    marker: {
      char: "•",
      size: 11,
      offsetX: 0,
      offsetY: 3.5,
      color: "#B79B72"
    },

    cardinal: {
      char: "◆",
      size: 16,
      offsetX: 0,
      offsetY: 5,
      color: "#E8CFA3"
    },

    hour: {
      char: "'",
      size: 13,
      offsetX: 0,
      offsetY: 4,
      color: "#D9C8B1",
      spacing: 7,
      start: 12,
      length: 0.70,
      width: 2
    },

    minute: {
      char: "·",
      size: 17,
      offsetX: 0,
      offsetY: 3,
      color: "#E1D9DC",
      spacing: 6,
      start: 9,
      length: 0.82
    },

    second: {
      char: "·",
      size: 15,
      offsetX: 0,
      offsetY: 2.5,
      color: "#AA7889",
      spacing: 5,
      start: 9,
      length: 0.92
    },

    pivot: {
      char: "•",
      size: 11,
      offsetX: 0,
      offsetY: 3.5,
      color: "#E8CFA3"
    }
  })

  // Dial lines change dynamically
  onHourLineOpacityChanged: canvas.requestPaint()
  onHourLineStartChanged: canvas.requestPaint()
  onHourLineEndChanged: canvas.requestPaint()
  onHourLineWidthChanged: canvas.requestPaint()
  onShowHourLinesChanged: canvas.requestPaint()
  onExpandedChanged: canvas.requestPaint()

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
      const radius = Math.min(width, height) * (root.expanded ? 0.39 : 0.40)
      const styles = root.expanded
      ? root.expandedGlyphStyles
      : root.glyphStyles

      // Helper: draw one character at a position.
      function glyph(styleName, x, y, rotation = 0) {
        const style = styles[styleName]

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

      if (root.expanded && root.showHourLines) {
        ctx.save()

        ctx.strokeStyle = root.hourLineColor
        ctx.globalAlpha = root.hourLineOpacity
        ctx.lineWidth = root.hourLineWidth
        ctx.lineCap = "round"

        for (let h = 0; h < 12; h++) {
          const angle = h * Math.PI / 6

          const inner = radius * root.hourLineStart
          const outer = radius * root.hourLineEnd

          ctx.beginPath()

          ctx.moveTo(
            cx + Math.sin(angle) * inner,
            cy - Math.cos(angle) * inner
          )

          ctx.lineTo(
            cx + Math.sin(angle) * outer,
            cy - Math.cos(angle) * outer
          )

          ctx.stroke()
        }

        ctx.restore()
      }

      // Circular dial
      for (let i = 0; i < root.glyphCount; i++) {
        const angle = i * 2 * Math.PI / root.glyphCount

        const x = cx + Math.sin(angle) * radius
        const y = cy - Math.cos(angle) * radius

        if (!root.expanded) {
          const markerInterval = root.glyphCount / 12
          const hourIndex = Math.round(i / markerInterval)

          if (i % markerInterval === 0) {
            const cardinal = hourIndex % 3 === 0
            glyph(cardinal ? "cardinal" : "marker", x, y)
          } else {
            glyph("dial", x, y)
          }

          continue
        }

        // Expanded dial: 120 positions, 60 true second marks.
        if (i % 10 === 0) {
          const cardinal = i % 30 === 0
          glyph(cardinal ? "cardinal" : "marker", x, y)
        } else if (i % 2 === 0) {
          glyph("dial", x, y)
        } else {
          glyph("halfSecond", x, y)
        }
      }

      // Helper: draw a hand from the center.
      function hand(angle, styleName) {
        const style = styles[styleName]

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
      (h + m / 60 + s / 3600) * Math.PI / 6

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
// Update theme colors dynamically (must be expanded to include each field)
  Connections {
    target: ThemeState

    function onMutedChanged() {
      canvas.requestPaint()
    }

    function onAccentChanged() {
      canvas.requestPaint()
    }
  }

  onWidthChanged: canvas.requestPaint()
  onHeightChanged: canvas.requestPaint()
}
