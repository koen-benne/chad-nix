# Example system setup configuration for desktop environments
# Add this to your host configuration to get helpful setup instructions
{
  # Enable system setup helper
  my.system-setup.enable = true;

  # Configure system components to check
  my.system-setup.checks = {
    pipewire = {
      name = "PipeWire Audio System";
      description = "Modern audio system with low latency and professional features";
      priority = "critical";
      checkCommands = [
        "command -v pipewire"
        "command -v wireplumber"
        "pgrep -x pipewire"
        "pgrep -x wireplumber"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install PipeWire and WirePlumber:"
          "sudo apt update"
          "sudo apt install pipewire pipewire-pulse wireplumber"
          "sudo systemctl --user --now enable pipewire pipewire-pulse wireplumber"
          "# Remove PulseAudio (optional but recommended):"
          "sudo apt remove --purge pulseaudio"
        ];
        fedora = [
          "# Install PipeWire (usually pre-installed on modern Fedora):"
          "sudo dnf install pipewire pipewire-pulseaudio wireplumber"
          "sudo systemctl --user --now enable pipewire pipewire-pulse wireplumber"
        ];
        arch = [
          "# Install PipeWire:"
          "sudo pacman -S pipewire pipewire-pulse wireplumber"
          "systemctl --user --now enable pipewire pipewire-pulse wireplumber"
        ];
        generic = [
          "# Install pipewire, pipewire-pulse, and wireplumber via your package manager"
          "# Enable user services: pipewire, pipewire-pulse, wireplumber"
        ];
      };
    };

    wayland = {
      name = "Wayland Display Server";
      description = "Modern display server for better security and performance";
      priority = "critical";
      checkCommands = [
        "test -n \"$WAYLAND_DISPLAY\""
        "command -v wayland-scanner"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install basic Wayland support:"
          "sudo apt install wayland-protocols libwayland-dev"
          "# For GNOME: already uses Wayland by default"
          "# For KDE: select 'Plasma (Wayland)' at login"
          "# Or install a Wayland compositor like Hyprland"
        ];
        fedora = [
          "# Wayland is default on modern Fedora"
          "# Install development packages if needed:"
          "sudo dnf install wayland-devel wayland-protocols-devel"
        ];
        arch = [
          "# Install Wayland:"
          "sudo pacman -S wayland wayland-protocols"
          "# Install a compositor like hyprland, sway, or use GNOME/KDE Wayland sessions"
        ];
        generic = [
          "# Install wayland and wayland-protocols"
          "# Use a Wayland compositor or desktop environment Wayland session"
        ];
      };
    };

    graphics-drivers = {
      name = "Graphics Drivers";
      description = "Hardware-accelerated graphics for smooth desktop experience";
      priority = "critical";
      checkCommands = [
        "test -c /dev/dri/card0"
        "glxinfo | grep -i 'direct rendering: yes'"
      ];
      setupInstructions = {
        ubuntu = [
          "# For Intel graphics:"
          "sudo apt install mesa-utils intel-media-va-driver"
          "# For NVIDIA:"
          "sudo ubuntu-drivers autoinstall"
          "# For AMD:"
          "sudo apt install mesa-utils mesa-vulkan-drivers"
        ];
        fedora = [
          "# For Intel graphics (usually pre-installed):"
          "sudo dnf install mesa-dri-drivers intel-media-driver"
          "# For NVIDIA:"
          "sudo dnf install nvidia-driver nvidia-settings"
          "# For AMD:"
          "sudo dnf install mesa-dri-drivers mesa-vulkan-drivers"
        ];
        arch = [
          "# For Intel graphics:"
          "sudo pacman -S mesa intel-media-driver"
          "# For NVIDIA:"
          "sudo pacman -S nvidia nvidia-settings"
          "# For AMD:"
          "sudo pacman -S mesa vulkan-radeon"
        ];
        generic = [
          "# Install appropriate graphics drivers for your GPU"
          "# Install mesa utilities: mesa-utils or equivalent"
        ];
      };
    };

    fonts = {
      name = "Font Rendering";
      description = "Good font rendering for readable text";
      priority = "recommended";
      checkCommands = [
        "fc-list | grep -i 'noto'"
        "test -f /etc/fonts/conf.d/10-sub-pixel-rgb.conf"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install good fonts:"
          "sudo apt install fonts-noto fonts-noto-color-emoji"
          "sudo apt install fontconfig"
          "# Enable better font rendering:"
          "sudo ln -sf /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/"
          "fc-cache -fv"
        ];
        fedora = [
          "# Install fonts:"
          "sudo dnf install google-noto-fonts google-noto-emoji-fonts"
          "# Font rendering is usually good by default"
        ];
        arch = [
          "# Install fonts:"
          "sudo pacman -S noto-fonts noto-fonts-colors-emoji"
          "# Enable font rendering improvements:"
          "sudo ln -sf /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/"
        ];
        generic = [
          "# Install Noto fonts and emoji fonts"
          "# Configure fontconfig for better rendering"
        ];
      };
    };

    polkit = {
      name = "PolicyKit Authentication";
      description = "Handles authentication for privileged operations";
      priority = "recommended";
      checkCommands = [
        "command -v pkexec"
        "pgrep -x polkitd"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install PolicyKit:"
          "sudo apt install policykit-1 policykit-1-gnome"
          "# For non-GNOME desktops, you might need a different agent"
        ];
        fedora = [
          "# Usually pre-installed, but if needed:"
          "sudo dnf install polkit polkit-gnome"
        ];
        arch = [
          "# Install PolicyKit:"
          "sudo pacman -S polkit"
          "# Install an authentication agent:"
          "sudo pacman -S polkit-gnome" # or lxsession, etc.
        ];
        generic = [
          "# Install polkit and a polkit authentication agent"
        ];
      };
    };

    bluetooth = {
      name = "Bluetooth Support";
      description = "Wireless connectivity for audio devices and peripherals";
      priority = "optional";
      checkCommands = [
        "command -v bluetoothctl"
        "systemctl --user is-active bluetooth"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install Bluetooth:"
          "sudo apt install bluez bluez-tools"
          "sudo systemctl enable --now bluetooth"
          "# Add user to bluetooth group:"
          "sudo usermod -a -G bluetooth $USER"
        ];
        fedora = [
          "# Usually pre-installed, enable if needed:"
          "sudo systemctl enable --now bluetooth"
        ];
        arch = [
          "# Install Bluetooth:"
          "sudo pacman -S bluez bluez-utils"
          "sudo systemctl enable --now bluetooth"
        ];
        generic = [
          "# Install bluez and bluez utilities"
          "# Enable bluetooth service"
        ];
      };
    };

    display-manager = {
      name = "Display Manager (tuigreet)";
      description = "Login manager for starting desktop sessions - tuigreet provides a clean TUI interface";
      priority = "critical";
      checkCommands = [
        "systemctl is-enabled greetd"
        "command -v tuigreet"
        "test -f /etc/greetd/config.toml"
      ];
      setupInstructions = {
        ubuntu = [
          "# Install greetd and tuigreet (may need building from source):"
          "# Check https://github.com/apognu/tuigreet for latest instructions"
          "# Alternative lightweight option:"
          "sudo apt install lightdm lightdm-gtk-greeter"
          "# Configure for Wayland sessions in /usr/share/wayland-sessions/"
        ];
        fedora = [
          "# Install greetd and tuigreet:"
          "sudo dnf copr enable peterwu/greetd"
          "sudo dnf install greetd tuigreet"
          "sudo systemctl enable greetd"
          "# Configure /etc/greetd/config.toml:"
          "sudo tee /etc/greetd/config.toml <<EOF"
          "[terminal]"
          "vt = 1"
          "[default_session]"
          "command = \"tuigreet --time --cmd Hyprland\""
          "user = \"greeter\""
          "EOF"
        ];
        arch = [
          "# Install greetd and tuigreet:"
          "sudo pacman -S greetd greetd-tuigreet"
          "sudo systemctl enable greetd"
          "# Configure /etc/greetd/config.toml:"
          "sudo tee /etc/greetd/config.toml <<EOF"
          "[terminal]"
          "vt = 1"
          "[default_session]"
          "command = \"tuigreet --time --remember --cmd Hyprland\""
          "user = \"greeter\""
          "EOF"
          "# Disable other display managers:"
          "sudo systemctl disable gdm sddm lightdm"
        ];
        generic = [
          "# Install greetd and tuigreet via your package manager or build from source"
          "# Enable greetd: sudo systemctl enable greetd"
          "# Configure /etc/greetd/config.toml with tuigreet command"
          "# Disable other display managers (gdm, sddm, lightdm)"
          "# See: https://github.com/kennylevinsen/greetd"
          "# See: https://github.com/apognu/tuigreet"
        ];
      };
    };

    session-files = {
      name = "Desktop Session Files";
      description = "Wayland session files for desktop environments to appear in login manager";
      priority = "recommended";
      checkCommands = [
        "test -d /usr/share/wayland-sessions"
        "ls /usr/share/wayland-sessions/*.desktop"
      ];
      setupInstructions = {
        ubuntu = [
          "# Create Hyprland session file:"
          "sudo mkdir -p /usr/share/wayland-sessions"
          "sudo tee /usr/share/wayland-sessions/hyprland.desktop <<EOF"
          "[Desktop Entry]"
          "Name=Hyprland"
          "Comment=An intelligent dynamic tiling Wayland compositor"
          "Exec=Hyprland"
          "Type=Application"
          "EOF"
        ];
        fedora = [
          "# Usually created automatically when installing desktop environments"
          "# For custom sessions like Hyprland:"
          "sudo tee /usr/share/wayland-sessions/hyprland.desktop <<EOF"
          "[Desktop Entry]"
          "Name=Hyprland"
          "Comment=An intelligent dynamic tiling Wayland compositor"
          "Exec=Hyprland"
          "Type=Application"
          "EOF"
        ];
        arch = [
          "# Install hyprland package creates session file automatically"
          "# For manual creation:"
          "sudo tee /usr/share/wayland-sessions/hyprland.desktop <<EOF"
          "[Desktop Entry]"
          "Name=Hyprland"
          "Comment=An intelligent dynamic tiling Wayland compositor"
          "Exec=Hyprland"
          "Type=Application"
          "EOF"
        ];
        generic = [
          "# Create desktop session files in /usr/share/wayland-sessions/"
          "# Format: [Desktop Entry] with Name, Comment, Exec, Type=Application"
        ];
      };
    };
  };
}
