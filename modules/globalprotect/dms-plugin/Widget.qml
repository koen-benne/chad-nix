import QtQuick
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

// Widget surface: presentational only. Instantiated per bar/placement per
// screen. Reads shared state from the Daemon surface via plugin global vars
// and delegates actions to the daemon instance instead of managing its own
// process, so multiple bars/monitors stay in sync and never double-trigger
// a connect/disconnect.
//
// Contract with Daemon.qml (relied on across separate files, so keep in sync):
//   - Reads plugin global vars "isConnected" (bool) and "actionState"
//     (string: "idle" | "connecting" | "disconnecting").
//   - Triggers the daemon's toggle() via PluginService.togglePlugin(pluginId).
PluginComponent {
    id: root

    layerNamespacePlugin: "globalprotect-vpn"

    readonly property var log: Log.scoped("GlobalProtect")

    PluginGlobalVar {
        id: connectedVar
        varName: "isConnected"
        defaultValue: false
    }

    PluginGlobalVar {
        id: actionStateVar
        varName: "actionState"
        defaultValue: "idle"
    }

    readonly property bool isConnected: connectedVar.value
    readonly property string actionState: actionStateVar.value
    readonly property bool isBusy: actionState !== "idle"

    // Control Center widget properties
    property string ccWidgetIcon: isBusy ? "sync" : (isConnected ? "vpn_lock" : "vpn_key_off")
    property string ccWidgetPrimaryText: "GlobalProtect"
    property string ccWidgetSecondaryText: {
        if (actionState === "connecting")
            return "Connecting...";
        if (actionState === "disconnecting")
            return "Disconnecting...";
        return isConnected ? "Connected" : "Disconnected";
    }
    property bool ccWidgetIsActive: isConnected

    // Handle toggle from Control Center
    onCcWidgetToggled: {
        toggle();
    }

    // Handle click from bar widget
    pillClickAction: function () {
        toggle();
    }

    // Ask the daemon instance to flip connection state via PluginService's
    // public toggle helper (rather than reaching into pluginDaemonInstances
    // directly), so every widget instance (across bars/monitors) shares one
    // connect/disconnect in flight instead of racing each other.
    function toggle() {
        if (!pluginService || !pluginService.togglePlugin(pluginId)) {
            log.warn("Daemon not ready yet, ignoring toggle");
        }
    }

    // Horizontal bar widget (for horizontal bars)
    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingSmall

            DankIcon {
                anchors.verticalCenter: parent.verticalCenter
                name: root.isBusy ? "sync" : (root.isConnected ? "vpn_lock" : "vpn_key_off")
                size: Theme.iconSizeSmall
                color: root.isConnected ? Theme.primary : Theme.widgetIconColor

                // Spinning animation for loading state
                RotationAnimator on rotation {
                    running: root.isBusy
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                }
            }

            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: "VPN"
                font.pixelSize: Theme.fontSizeSmall
                color: root.isConnected ? Theme.primary : Theme.widgetTextColor
            }
        }
    }

    // Vertical bar widget (for vertical bars)
    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS

            DankIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                name: root.isBusy ? "sync" : (root.isConnected ? "vpn_lock" : "vpn_key_off")
                size: Theme.iconSizeSmall
                color: root.isConnected ? Theme.primary : Theme.widgetIconColor

                // Spinning animation for loading state
                RotationAnimator on rotation {
                    running: root.isBusy
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                }
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "VPN"
                font.pixelSize: Theme.fontSizeXS
                color: root.isConnected ? Theme.primary : Theme.widgetTextColor
            }
        }
    }
}
