{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.desktop;

  # NixGL setup for standalone home-manager mode
  nixGLPackage =
    if config.my.hyprland.nixgl.variant == "auto" then
      inputs.nixgl.packages.${pkgs.system}.nixGLDefault
    else if config.my.hyprland.nixgl.variant == "intel" then
      inputs.nixgl.packages.${pkgs.system}.nixGLIntel
    else if config.my.hyprland.nixgl.variant == "nvidia" then
      inputs.nixgl.packages.${pkgs.system}.nixGLNvidia
    else
      inputs.nixgl.packages.${pkgs.system}.nixGLMesa;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop";
    windowManager = mkOption {
      type = types.enum ["hyprland" "niri"];
      default = "hyprland";
      description = mdDoc "Window manager to use";
    };
  };
  options.networking.networkmanager = {
    enable = mkEnableOption "networkmanager";
  };

  config = mkIf config.my.desktop.enable {
    my.hyprland.enable = cfg.windowManager == "hyprland";
    my.niri.enable = cfg.windowManager == "niri";
    my.lockscreen.enable = true;
    my.theme.enable = true;
    my.dankmaterialshell.enable = true;
    my.foot.enable = true;
    my.thunderbird.enable = true;
    my.qutebrowser.enable = true;

    # Standalone mode packages
    home.packages = [
      # NixGL package
      nixGLPackage

      # Desktop essentials for standalone mode
      pkgs.hyprpicker
      pkgs.playerctl
      pkgs.nautilus
    ];

    # Enable nixGL-wrapped desktop entries for GUI applications
    my.nixgl-desktop.enable = true;
    my.nixgl-desktop.applications = {
      nautilus = {
        name = "Files";
        exec = "nautilus";
        icon = "org.gnome.Nautilus";
        categories = ["System" "FileManager"];
        comment = "Access and organize files";
        mimeType = ["inode/directory"];
      };

      zen = {
        name = "Zen Browser";
        exec = "zen";
        icon = "zen";
        categories = ["Network" "WebBrowser"];
        comment = "Privacy-focused web browser";
        mimeType = ["text/html" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
      };
    };

    # Enable system setup helper for standalone mode
    my.system-setup.enable = true;
    my.system-setup.checks = {
      dbus = {
        name = "D-Bus Message Bus";
        description = "Inter-process communication system required for desktop applications";
        priority = "critical";
        checkCommands = [];
        setupInstructions = {
          ubuntu = [
            "sudo apt update"
            "sudo apt install dbus"
            "sudo systemctl enable --now dbus"
          ];
          fedora = [
            "sudo dnf install dbus"
            "sudo systemctl enable --now dbus"
          ];
          arch = [
            "sudo pacman -S dbus"
            "sudo systemctl enable --now dbus"
          ];
          generic = [
            "Install dbus via your package manager"
            "Enable and start the dbus service"
          ];
        };
      };

      pipewire = {
        name = "PipeWire Audio System";
        description = "Modern audio system with low latency and professional features";
        priority = "critical";
        checkCommands = [];
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
        checkCommands = [];
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
        checkCommands = [];
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
        description = "Login manager for graphical sessions - follow Arch Wiki for setup";
        priority = "critical";
        checkCommands = [];
        setupInstructions = {
          ubuntu = [
            "# Follow Arch Wiki: https://wiki.archlinux.org/title/Greetd"
            "sudo apt install greetd greetd-tuigreet  # If available"
            "# Alternative: sudo apt install lightdm lightdm-gtk-greeter"
          ];
          fedora = [
            "# Follow Arch Wiki: https://wiki.archlinux.org/title/Greetd"
            "sudo dnf copr enable peterwu/greetd"
            "sudo dnf install greetd greetd-tuigreet"
          ];
          arch = [
            "# Follow Arch Wiki: https://wiki.archlinux.org/title/Greetd"
            "sudo pacman -S greetd greetd-tuigreet"
          ];
          generic = [
            "# Follow Arch Wiki: https://wiki.archlinux.org/title/Greetd"
            "# Install greetd and tuigreet via your package manager"
          ];
        };
      };
    };
  };
}

