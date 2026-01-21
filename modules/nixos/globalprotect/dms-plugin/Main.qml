import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    layerNamespacePlugin: "globalprotect-vpn"

    property bool isConnected: false
    property bool isChecking: false
    property var activeProcess: null  // Track the running gpclient process

    // isBusy is true when we have an active connection/disconnection process
    readonly property bool isBusy: activeProcess !== null

    // Control Center widget properties
    property string ccWidgetIcon: isBusy ? "sync" : (isConnected ? "vpn_lock" : "vpn_key_off")
    property string ccWidgetPrimaryText: "GlobalProtect"
    property string ccWidgetSecondaryText: isBusy ? "Connecting..." : (isConnected ? "Connected" : "Disconnected")
    property bool ccWidgetIsActive: isConnected

    // Handle toggle from Control Center
    onCcWidgetToggled: {
        toggle()
    }

    // Handle click from bar widget
    pillClickAction: function() {
        console.log("[GlobalProtect] Widget clicked! isConnected:", root.isConnected)
        toggle()
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
        if (isChecking) return
        isChecking = true

        var process = processComponent.createObject(root, {
            command: ["ip", "link", "show", "tun0"],
            running: true
        })

        process.exited.connect(function(code, status) {
            root.isConnected = (code === 0)
            isChecking = false
            process.destroy()
        })
    }

    // Connect VPN
    function connectVPN() {
        // Don't start a new connection if one is already in progress
        if (activeProcess !== null) {
            return
        }

        console.log("[GlobalProtect] Starting connection process...")

        activeProcess = processComponent.createObject(root, {
            command: ["pkexec", "env", "DISPLAY=:0", "WAYLAND_DISPLAY=wayland-1", "@gpclient@", "connect", "gp.iodigital.com", "--as-gateway"],
            running: true
        })

        if (!activeProcess) {
            console.log("[GlobalProtect] Failed to create process!")
            ToastService.showError("Failed to start VPN process")
            return
        }

        // Log output for debugging (if available)
        if (activeProcess.stdout) {
            activeProcess.stdout.connect(function(data) {
                console.log("[gpclient connect stdout]", data)
            })
        }

        if (activeProcess.stderr) {
            activeProcess.stderr.connect(function(data) {
                console.log("[gpclient connect stderr]", data)
            })
        }

        // gpclient stays running as a daemon, so we check connection status instead
        // Start a timer to check if connection succeeded
        connectionCheckTimer.start()

        ToastService.showInfo("Connecting to VPN...")
    }

    // Timer to check if VPN connected successfully
    Timer {
        id: connectionCheckTimer
        interval: 2000
        repeat: true
        running: false

        property int attempts: 0

        onTriggered: {
            attempts++

            console.log("[GlobalProtect] Connection check timer fired, attempt:", attempts, "isConnected:", root.isConnected, "activeProcess:", root.activeProcess)

            // Check if connected (tun0 exists)
            if (root.isConnected) {
                // Connection successful
                console.log("[GlobalProtect] Connection detected! Clearing activeProcess")
                ToastService.showInfo("VPN Connected")
                root.activeProcess = null  // Clear loading state
                console.log("[GlobalProtect] After clearing: activeProcess:", root.activeProcess, "isBusy:", root.isBusy)
                stop()
                attempts = 0
            } else if (attempts >= 15) {
                // Timeout after 30 seconds
                ToastService.showError("VPN Connection Timeout")
                if (root.activeProcess) {
                    root.activeProcess.destroy()
                    root.activeProcess = null
                }
                stop()
                attempts = 0
            }
        }
    }

    // Disconnect VPN
    function disconnectVPN() {
        // Don't start a new disconnection if one is already in progress
        if (activeProcess !== null) {
            return
        }

        console.log("[GlobalProtect] Starting disconnection process...")

        activeProcess = processComponent.createObject(root, {
            command: ["pkexec", "@gpclient@", "disconnect"],
            running: true
        })

        if (!activeProcess) {
            console.log("[GlobalProtect] Failed to create process!")
            ToastService.showError("Failed to start VPN process")
            return
        }

        // Log output for debugging (if available)
        if (activeProcess.stdout) {
            activeProcess.stdout.connect(function(data) {
                console.log("[gpclient disconnect stdout]", data)
            })
        }

        if (activeProcess.stderr) {
            activeProcess.stderr.connect(function(data) {
                console.log("[gpclient disconnect stderr]", data)
            })
        }

        // Disconnect command completes quickly
        activeProcess.exited.connect(function(code, status) {
            console.log("[gpclient disconnect] Process exited with code:", code, "status:", status)

            if (code === 0) {
                ToastService.showInfo("VPN Disconnected")
            } else {
                ToastService.showError("VPN Disconnection Failed (code: " + code + ")")
            }

            // Clean up process and update status - explicitly reference root property
            if (root.activeProcess) {
                root.activeProcess.destroy()
                root.activeProcess = null
            }
            statusTimer.restart()
        })

        ToastService.showInfo("Disconnecting VPN...")
    }

    // Toggle VPN
    function toggle() {
        console.log("[GlobalProtect] Toggle called, isConnected:", isConnected, "isBusy:", isBusy)
        if (isConnected) {
            disconnectVPN()
        } else {
            connectVPN()
        }
    }

    Component {
        id: processComponent
        Process {}
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

    Component.onCompleted: {
        console.log("[GlobalProtect] Plugin initialized")
        checkStatus()
    }
}
