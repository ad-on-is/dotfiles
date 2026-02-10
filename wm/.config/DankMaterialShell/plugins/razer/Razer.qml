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
    property bool charging: false

    Timer {
        interval: 1000

        running: true

        repeat: true

        onTriggered: razerInfo.running = true
    }

    Process {
        id: razerInfo
        command: ["python3", "/home/adonis/.local/scripts/wm/razerbattery.py"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const [name, bat, charge, dpi, brightness] = this.text.split("\n");
                charging = charge === "True";
                displayText = `${name} ${bat}%`;
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: 3
            DankIcon {
                name: "mouse"
                size: Theme.barIconSize(root.barThickness)
                color: {
                    return charging ? Theme.primary : Theme.widgetTextColor;
                }
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: root.displayText
                font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale)
                color: Theme.widgetTextColor
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
