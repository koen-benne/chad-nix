#!/usr/bin/env bash

# Launch Hyprland with NixGL wrapper
# This script automatically detects and uses the appropriate NixGL variant

set -euo pipefail

# Check if running on NixOS (where NixGL isn't needed)
if [[ -f /etc/NIXOS ]]; then
    echo "Running on NixOS, launching Hyprland directly..."
    exec Hyprland "$@"
fi

# Try to detect graphics drivers
NIXGL_VARIANT="nixGLIntel"  # Default fallback

if command -v nvidia-smi >/dev/null 2>&1; then
    echo "NVIDIA GPU detected, using nixGLNvidia..."
    NIXGL_VARIANT="nixGLNvidia"
elif lspci | grep -i "amd" | grep -i "vga\|3d\|display" >/dev/null 2>&1; then
    echo "AMD GPU detected, using nixGLMesa..."
    NIXGL_VARIANT="nixGLMesa"  
else
    echo "Intel/Generic GPU detected, using nixGLIntel..."
    NIXGL_VARIANT="nixGLIntel"
fi

# Check if the NixGL variant exists in PATH
if ! command -v "$NIXGL_VARIANT" >/dev/null 2>&1; then
    echo "Warning: $NIXGL_VARIANT not found in PATH, falling back to nixGLIntel"
    NIXGL_VARIANT="nixGLIntel"
fi

echo "Launching Hyprland with $NIXGL_VARIANT..."
exec "$NIXGL_VARIANT" Hyprland "$@"