{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop";
  };
  options.networking.networkmanager = {
    enable = mkEnableOption "networkmanager";
  };

  config = lib.mkIf config.my.desktop.enable {
    my.hyprland.enable = true;
    my.lockscreen.enable = true;
    my.theme.enable = true;
    my.uxplay.enable = true;
    my.waybar.enable = true;
    my.foot.enable = true;
    my.thunderbird.enable = true;
    my.qutebrowser.enable = true;
    
    # Enable system setup helper for standalone mode
    my.system-setup.enable = true;
    my.tuigreet.enable = true;
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
            "sudo apt update"
            "sudo apt install pipewire pipewire-pulse wireplumber"
            "systemctl --user --now enable pipewire pipewire-pulse wireplumber"
          ];
          fedora = [
            "sudo dnf install pipewire pipewire-pulseaudio wireplumber"
            "systemctl --user --now enable pipewire pipewire-pulse wireplumber"
          ];
          arch = [
            "sudo pacman -S pipewire pipewire-pulse wireplumber"
            "systemctl --user --now enable pipewire pipewire-pulse wireplumber"
          ];
          generic = [
            "Install pipewire, pipewire-pulse, and wireplumber via your package manager"
            "Enable user services: pipewire, pipewire-pulse, wireplumber"
          ];
        };
      };
      
      wayland = {
        name = "Wayland Display Server";
        description = "Required for Hyprland and modern desktop features";
        priority = "critical";
        checkCommands = [
          "test -n \"$WAYLAND_DISPLAY\""
          "command -v wayland-scanner"
        ];
        setupInstructions = {
          ubuntu = [
            "sudo apt install wayland-protocols libwayland-dev"
            "Install a Wayland compositor or use GNOME/KDE Wayland session"
          ];
          fedora = [
            "sudo dnf install wayland-devel wayland-protocols-devel"
            "Wayland is default on modern Fedora"
          ];
          arch = [
            "sudo pacman -S wayland wayland-protocols"
            "Install a compositor like hyprland or use desktop Wayland session"
          ];
          generic = [
            "Install wayland and wayland-protocols packages"
            "Use a Wayland compositor or desktop environment"
          ];
        };
      };
      
      graphics-drivers = {
        name = "Graphics Drivers";
        description = "Hardware acceleration for smooth desktop and nixGL compatibility";
        priority = "critical";
        checkCommands = [
          "test -c /dev/dri/card0"
          "command -v glxinfo && glxinfo | grep -q 'direct rendering: yes'"
        ];
        setupInstructions = {
          ubuntu = [
            "# For Intel: sudo apt install mesa-utils intel-media-va-driver"
            "# For NVIDIA: sudo ubuntu-drivers autoinstall"
            "# For AMD: sudo apt install mesa-utils mesa-vulkan-drivers"
          ];
          fedora = [
            "# For Intel: sudo dnf install mesa-dri-drivers intel-media-driver"
            "# For NVIDIA: sudo dnf install nvidia-driver nvidia-settings"
            "# For AMD: sudo dnf install mesa-dri-drivers mesa-vulkan-drivers"
          ];
          arch = [
            "# For Intel: sudo pacman -S mesa intel-media-driver"
            "# For NVIDIA: sudo pacman -S nvidia nvidia-settings"
            "# For AMD: sudo pacman -S mesa vulkan-radeon"
          ];
          generic = [
            "Install appropriate graphics drivers for your GPU"
            "Install mesa utilities for OpenGL support"
          ];
        };
      };
      
      display-manager = {
        name = "Display Manager (greetd + tuigreet)";
        description = "Login manager for graphical sessions - tuigreet provides clean TUI interface";
        priority = "critical";
        checkCommands = [
          "systemctl is-enabled greetd"
          "command -v tuigreet"
          "test -f /etc/greetd/config.toml"
          "test -f /etc/pam.d/greetd"
          "id greetd"
          "test -c /dev/tty7"
          "groups greetd | grep -q tty"
        ];
        setupInstructions = {
          ubuntu = [
            "# Install both greetd and tuigreet via native packages (recommended):"
            "sudo apt update"
            "sudo apt install greetd greetd-tuigreet  # If available in repos"
            "# If not available: build from source or use alternative:"
            "# sudo apt install lightdm lightdm-gtk-greeter"
            "# Setup user and permissions:"
            "sudo useradd -r -s /bin/false greetd"
            "sudo usermod -a -G tty greetd"
            "sudo systemctl enable greetd"
            "# Run setup helper: ~/.local/bin/setup-tuigreet"
          ];
          fedora = [
            "# Install greetd and tuigreet via native packages:"
            "sudo dnf copr enable peterwu/greetd"
            "sudo dnf install greetd greetd-tuigreet"
            "sudo useradd -r -s /bin/false greetd"
            "sudo usermod -a -G tty greetd"
            "sudo systemctl enable greetd"
            "# Theme and config helpers provided by home-manager"
            "# Run setup helper: ~/.local/bin/setup-tuigreet"
          ];
          arch = [
            "# Install greetd and tuigreet via native packages:"
            "sudo pacman -S greetd greetd-tuigreet"
            "sudo useradd -r -s /bin/false greetd"
            "sudo usermod -a -G tty greetd"
            "sudo systemctl enable greetd"
            "# Theme and config helpers provided by home-manager"
            "# Run setup helper: ~/.local/bin/setup-tuigreet"
          ];
          generic = [
            "# Install BOTH greetd and tuigreet via your native package manager"
            "# This prevents GREETD_SOCK compatibility issues"
            "# Create greetd user: sudo useradd -r -s /bin/false greetd"
            "# Add to tty group: sudo usermod -a -G tty greetd"
            "# Enable service: sudo systemctl enable greetd"
            "# Run setup helper: ~/.local/bin/setup-tuigreet"
          ];
        };
      };
    };
  };
}

