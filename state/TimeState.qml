pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }


    readonly property date now: clock.date
    readonly property int hours: now.getHours()
    readonly property int minutes: now.getMinutes()
    readonly property int seconds: now.getSeconds()

    readonly property string formattedTime:
        Qt.formatDateTime(now, "hh:mm:ss")
}
