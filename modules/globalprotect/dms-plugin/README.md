# GlobalProtect Control

GlobalProtect VPN toggle widget for DankMaterialShell Control Center.

## Features

- Quick toggle VPN on/off from Control Center
- Shows connection status with icon
- Uses pkexec for password prompts
- Auto-updates status every 2 seconds

## Architecture

This is a composite plugin with two surfaces:

- **`Daemon.qml`** - instantiated once regardless of how many bars/monitors
  are configured. Owns the `tun0` status polling timer and the
  connect/disconnect `pkexec gpclient` processes, and publishes state via
  plugin global vars (`isConnected`, `isBusy`).
- **`Widget.qml`** - purely presentational. Instantiated per bar/placement
  per screen. Renders the DankBar pill and Control Center widget, reads
  state via `PluginGlobalVar`, and delegates clicks to the daemon instance.

This split means multiple monitors/bars never poll `tun0` independently and
can't race each other into spawning two connect/disconnect processes at once.

## Installation

1. Copy this plugin to `~/.config/DankMaterialShell/plugins/globalprotect-control/`
2. Open Settings → Plugins
3. Click "Scan for Plugins"
4. Enable "GlobalProtect Control"
5. Restart DMS: `dms restart`

## Usage

Open Control Center and toggle the GlobalProtect VPN button. The icon will change based on connection status.

## Requirements

- `gpclient` installed and in PATH
- `polkit` for authentication prompts
- GlobalProtect VPN configured with `--as-gateway` flag

## License

MIT
