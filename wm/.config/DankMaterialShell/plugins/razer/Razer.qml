import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins
import Quickshell
import Quickshell.Io

PluginComponent {
    id: root

    property string displayText: "Loading"

    Timer {
        interval: 1000

        running: true

        repeat: true

        onTriggered: razerInfo.running = true
    }

    Process {
        id: razerInfo
        command: ["bash", "-c", "'razer-cli -ls | tail -n +2 | 2yaml | yq"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: displayText = this.text
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingS

            DankIcon {
                name: "widgets"
                size: Theme.iconSize
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: root.displayText
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                name: "widgets"
                size: Theme.iconSize
                color: Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.displayText
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
