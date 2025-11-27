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

      # TODO: Remove after upgrading to home-manager 25.11 - targets.genericLinux will be in stable
      # Import targets.genericLinux from home-manager-unstable since it's not in 25.05
      # This provides GPU support and XDG integration for non-NixOS systems
      (inputs.home-manager-unstable + "/modules/targets/generic-linux.nix")
    ];

  config = {
    # Enable generic Linux support - provides XDG dirs, paths, nix env, terminfo, etc.
    targets.genericLinux.enable = true;

    # Enable GPU driver integration (requires sudo to set up via non-nixos-gpu-setup)
    # This creates /run/opengl-driver symlink via systemd service
    # Home Manager will notify you to run the setup script after switch
    targets.genericLinux.gpu.enable = true;

    # Detection flag for home-manager standalone mode
    my.isStandalone = true;

    # Make sys available as an alias to config for home.nix files
    # This mimics the behavior of extraSpecialArgs = { sys = config; }
    _module.args.sys = config;

    # Essential packages for home-manager standalone mode
    home.packages = [
      pkgs.home-manager
    ];
  };
}
