import QtQuick
import QtQuick.Controls
import "../state"

Item {
  id: root

  TimeInput {
    anchors.horizontalCenter: parent.horizontalCenter

    durationSeconds: TimerState.selectedDurationSeconds

    onDurationEdited: seconds => {
      TimerState.setSelectedDuration(seconds)
    }
  }

  Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 10

    Repeater {
      model: [1, 5, 10, 25]

      delegate: PhantomButton {
        required property int modelData

        text: modelData + "m"

        selected:
        TimerState.selectedDurationSeconds === modelData * 60

        onClicked: {
          TimerState.setSelectedDuration(modelData * 60)
        }
      }
    }
  }

  implicitWidth: controls.implicitWidth
  implicitHeight: controls.implicitHeight

  Column {
    id: controls
    anchors.centerIn: parent
    spacing: 14

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: TimerState.formattedRemaining
      color: ThemeState.foreground
      font.family: "GeistMono Nerd Font"
      font.pixelSize: 28
    }

    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 10

      Repeater {
        model: [1, 5, 10, 25]

        delegate: PhantomButton {
          required property int modelData

          text: modelData + "m"
          selected: root.selectedMinutes === modelData

          onClicked: {
            root.selectedMinutes = modelData
          }
        }
      }
    }

    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 12

      PhantomButton {
        text: TimerState.running
        ? "Pause"
        : TimerState.paused
        ? "Resume"
        : "Start"

        selected: TimerState.running

        onClicked: {
          if (TimerState.running)
          TimerState.pause()
          else if (TimerState.paused)
          TimerState.resume()
          else
          TimerState.startSelected()
        }
      }

      PhantomButton {
        text: "Reset"
        enabled: TimerState.durationMs > 0
        onClicked: TimerState.reset()
      }
    }
  }
}
