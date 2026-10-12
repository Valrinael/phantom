pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property color background: "#17151B"
    property color foreground: "#E1D9DC"
    property color muted: "#706575"
    property color accent: "#C6A56B"
    property color secondaryAccent: "#AA7889"

    property color hourHand: "#D9C8B1"
    property color minuteHand: "#E1D9DC"
    property color secondHand: secondaryAccent

    property color hourMarker: "#E8CFA3"
    property color minuteMarker: "#B79B72"
}
