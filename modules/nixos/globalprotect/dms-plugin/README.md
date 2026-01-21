# GlobalProtect Control

GlobalProtect VPN toggle widget for DankMaterialShell Control Center.

## Features

- Quick toggle VPN on/off from Control Center
- Shows connection status with icon
- Uses pkexec for password prompts
- Auto-updates status every 2 seconds

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
