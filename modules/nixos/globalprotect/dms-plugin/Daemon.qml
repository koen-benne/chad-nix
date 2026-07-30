import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Modules.Plugins

// Daemon surface: instantiated once regardless of how many bars/screens show
// the widget. Owns VPN status polling and connect/disconnect actions.
//
// Contract with Widget.qml (relied on across separate files, so keep in sync):
//   - Publishes plugin global vars "isConnected" (bool) and "actionState"
//     (string: "idle" | "connecting" | "disconnecting").
//   - Exposes a no-arg toggle() function, invoked by Widget.qml indirectly
//     via PluginService.togglePlugin(pluginId).
PluginComponent {
    id: root

    readonly property var log: Log.scoped("GlobalProtect")

    property bool isConnected: false
    property bool isChecking: false
    property var activeProcess: null // Track the running gpclient process

    // "idle" | "connecting" | "disconnecting"
    property string actionState: "idle"
    // Convenience boolean for the widget's spin animation
    readonly property bool isBusy: actionState !== "idle"

    onIsConnectedChanged: {
        if (pluginId)
            PluginService.setGlobalVar(pluginId, "isConnected", isConnected);
    }

    onActionStateChanged: {
        if (pluginId)
            PluginService.setGlobalVar(pluginId, "actionState", actionState);
    }

    // Timer to check VPN status
    Timer {
        id: statusTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: root.checkStatus()
    }

    // Check if VPN is connected
    function checkStatus() {
        if (isChecking)
            return;
        isChecking = true;

        var process = statusProcessComponent.createObject(root, {
            command: ["ip", "link", "show", "tun0"],
            running: true
        });

        process.exited.connect(function (code, status) {
            root.isConnected = (code === 0);
            isChecking = false;
            process.destroy();
        });
    }

    // Stop and release an in-flight process, telling the real OS process to
    // terminate instead of just letting the QML wrapper get garbage collected.
    function _stopActiveProcess() {
        if (!activeProcess)
            return;
        activeProcess.running = false;
        activeProcess.destroy();
        activeProcess = null;
    }

    // Connect VPN
    function connectVPN() {
        // Don't start a new connection if one is already in progress
        if (activeProcess !== null) {
            return;
        }

        log.info("Starting connection process...");
        actionState = "connecting";

        // Read the live session environment instead of hardcoding display
        // values - pkexec strips the environment from the launched process,
        // so we explicitly pass these through via `env`.
        var display = Quickshell.env("DISPLAY") || ":0";
        var waylandDisplay = Quickshell.env("WAYLAND_DISPLAY") || "wayland-1";

        activeProcess = connectProcessComponent.createObject(root, {
            command: ["pkexec", "env", "DISPLAY=" + display, "WAYLAND_DISPLAY=" + waylandDisplay, "@gpclient@", "connect", "gp.iodigital.com", "--as-gateway"],
            running: true
        });

        if (!activeProcess) {
            log.error("Failed to create process!");
            actionState = "idle";
            ToastService.showError("Failed to start VPN process");
            return;
        }

        // gpclient stays running as a daemon, so we check connection status instead
        // Start a timer to check if connection succeeded
        connectionCheckTimer.start();

        ToastService.showInfo("Connecting to VPN...");
    }

    // Timer to check if VPN connected successfully
    Timer {
        id: connectionCheckTimer
        interval: 2000
        repeat: true
        running: false

        property int attempts: 0

        onTriggered: {
            attempts++;

            root.log.debug("Connection check attempt:", attempts, "isConnected:", root.isConnected);

            // Check if connected (tun0 exists)
            if (root.isConnected) {
                // Connection successful
                root.log.info("Connection detected, clearing activeProcess");
                ToastService.showInfo("VPN Connected");
                root.activeProcess = null; // gpclient stays running as a daemon - just drop our reference
                root.actionState = "idle";
                stop();
                attempts = 0;
            } else if (attempts >= 15) {
                // Timeout after 30 seconds
                ToastService.showError("VPN Connection Timeout");
                root._stopActiveProcess();
                root.actionState = "idle";
                stop();
                attempts = 0;
            }
        }
    }

    // Disconnect VPN
    function disconnectVPN() {
        // Don't start a new disconnection if one is already in progress
        if (activeProcess !== null) {
            return;
        }

        log.info("Starting disconnection process...");
        actionState = "disconnecting";

        activeProcess = disconnectProcessComponent.createObject(root, {
            command: ["pkexec", "@gpclient@", "disconnect"],
            running: true
        });

        if (!activeProcess) {
            log.error("Failed to create process!");
            actionState = "idle";
            ToastService.showError("Failed to start VPN process");
            return;
        }

        // Disconnect command completes quickly
        activeProcess.exited.connect(function (code, status) {
            root.log.info("disconnect process exited with code:", code, "status:", status);

            if (code === 0) {
                ToastService.showInfo("VPN Disconnected");
            } else {
                ToastService.showError("VPN Disconnection Failed (code: " + code + ")");
            }

            // Clean up process and update status - explicitly reference root property
            if (root.activeProcess) {
                root.activeProcess.destroy();
                root.activeProcess = null;
            }
            root.actionState = "idle";
            statusTimer.restart();
        });

        ToastService.showInfo("Disconnecting VPN...");
    }

    // Toggle VPN
    function toggle() {
        log.info("Toggle called, isConnected:", isConnected, "actionState:", actionState);
        if (isConnected) {
            disconnectVPN();
        } else {
            connectVPN();
        }
    }

    Component {
        id: statusProcessComponent
        Process {}
    }

    Component {
        id: connectProcessComponent
        Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    if (text.trim())
                        root.log.debug("connect stdout:", text.trim());
                }
            }
            stderr: StdioCollector {
                onStreamFinished: {
                    if (text.trim()) {
                        root.log.warn("connect stderr:", text.trim());
                        ToastService.showError("GlobalProtect", text.trim());
                    }
                }
            }
        }
    }

    Component {
        id: disconnectProcessComponent
        Process {
            stdout: StdioCollector {
                onStreamFinished: {
                    if (text.trim())
                        root.log.debug("disconnect stdout:", text.trim());
                }
            }
            stderr: StdioCollector {
                onStreamFinished: {
                    if (text.trim()) {
                        root.log.warn("disconnect stderr:", text.trim());
                        ToastService.showError("GlobalProtect", text.trim());
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        log.info("Daemon started");
        checkStatus();
    }

    Component.onDestruction: {
        log.info("Daemon stopped");
        // Don't leave a pkexec'd gpclient process running detached with
        // nothing left to track it if the plugin gets disabled mid-action.
        _stopActiveProcess();
    }
}
