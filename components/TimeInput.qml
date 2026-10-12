import QtQuick
import QtQuick.Controls
import "../state"

Item {
    id: root

    property int durationSeconds: TimerState.selectedDurationSeconds
    signal durationEdited(int seconds)

    implicitWidth: fields.implicitWidth
    implicitHeight: fields.implicitHeight

    function pad(value) {
        return String(value).padStart(2, "0")
    }

    function updateDuration() {
        const h = Math.min(99, Math.max(0, parseInt(hours.text) || 0))
        const m = Math.min(59, Math.max(0, parseInt(minutes.text) || 0))
        const s = Math.min(59, Math.max(0, parseInt(seconds.text) || 0))

        durationEdited(h * 3600 + m * 60 + s)
    }

    Row {
        id: fields
        spacing: 2

        component TimeField: TextField {
            property int maximum: 59
            property int minimum: 0

            implicitWidth: 44
            implicitHeight: 36

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            color: ThemeState.foreground
            selectionColor: ThemeState.accent
            selectedTextColor: ThemeState.background

            font.family: "GeistMono Nerd Font"
            font.pixelSize: 18

            validator: IntValidator {
                bottom: minimum
                top: maximum
            }

            background: Rectangle {
                radius: 4
                color: "transparent"
                border.color: parent.activeFocus
                    ? ThemeState.accent
                    : "transparent"
            }

            onEditingFinished: root.updateDuration()

            WheelHandler {
                target: null

                onWheel: event => {
                    const direction = event.angleDelta.y > 0 ? 1 : -1
                    const next = Math.max(
                        minimum,
                        Math.min(maximum, (parseInt(parent.text) || 0) + direction)
                    )

                    parent.text = root.pad(next)
                    root.updateDuration()
                    event.accepted = true
                }
            }
        }

        TimeField {
            id: hours
            maximum: 99
            text: root.pad(Math.floor(root.durationSeconds / 3600))
        }

        Text {
            text: ":"
            color: ThemeState.muted
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeField {
            id: minutes
            text: root.pad(Math.floor((root.durationSeconds % 3600) / 60))
        }

        Text {
            text: ":"
            color: ThemeState.muted
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }

        TimeField {
            id: seconds
            text: root.pad(root.durationSeconds % 60)
        }
    }
}
