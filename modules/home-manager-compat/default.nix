# Home-Manager Compatibility Layer
#
# Auto-discovers compat.nix files from common and nixos modules to provide
# the sys.* options that home.nix files expect when running home-manager
# standalone on Linux systems that can't use NixOS system management.
#
# This ensures existing home.nix files work unchanged without needing
# to maintain separate home-manager-only versions.
#
# Features:
# - Sets config.my.isStandalone = true for detection in home.nix modules
# - Provides sys.* options via compat.nix files
# - Makes sys available as alias to config for backward compatibility
# - Uses targets.genericLinux for GPU support and XDG integration
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports =
    # Auto-discovery of compat.nix files
    lib.my.getCompatModules [../common ../nixos]
    ++ [
      # Home-manager standalone specific modules
      ./system-setup
    ];

  config = {
    # Enable generic Linux support - provides XDG dirs, paths, nix env, terminfo, etc.
    targets.genericLinux.enable = true;

    # Enable GPU driver integration (requires sudo to set up via non-nixos-gpu-setup)
    # This creates /run/opengl-driver symlink via systemd service
    # Home Manager will notify you to run the setup script after switch
    targets.genericLinux.gpu.enable = true;

    # Enable fontconfig to generate proper font preference rules
    # Without this, Stylix's font settings don't take effect and the system
    # falls back to default fonts (usually DejaVu), causing Nerd Font icons
    # to not render correctly
    fonts.fontconfig.enable = true;

    # Detection flag for home-manager standalone mode
    my.isStandalone = true;

    # Make sys available as an alias to config for home.nix files
    # This mimics the behavior of extraSpecialArgs = { sys = config; }
    _module.args.sys = config;

    # Set nix-path to use flake's nixpkgs for <nixpkgs> lookups in nix-shell and legacy commands
    nix.settings.nix-path = ["nixpkgs=${pkgs.path}"];

    # Essential packages for home-manager standalone mode
    home.packages = [
      pkgs.home-manager
    ];
  };
}
