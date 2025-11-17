# TODO: implement nwg-displays
{
  config,
  lib,
  pkgs,
  sys,
  inputs,
  ...
}: let
  inherit (lib) mkIf optionalString;
  scripts = ./scripts;

  # Import shared config
  sharedConfig = import ./config.nix;

  # Get appropriate browser command based on context
  browserCmd = if config.my.isStandalone then "nixGL zen" else "zen";

  # Helper functions for conditional nixGL wrapping
  wrapCmd = cmd: if config.my.isStandalone then "nixGLIntel ${cmd}" else cmd;
in {
  config = mkIf (sys.my.hyprland.enable or config.my.hyprland.enable) {
    # Hyprland-specific packages for standalone mode
    home.packages = mkIf config.my.isStandalone [
      pkgs.hyprpolkitagent
    ];

    # Enable DMS for both NixOS and standalone mode
    my.dankmaterialshell.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      extraConfig = ''
        ${sharedConfig { inherit scripts wrapCmd; }}

        # Browser binding (different for NixOS vs standalone)
        bind = $mainMod, W, exec, ${browserCmd}

        ${optionalString (sys ? networking && sys.networking.networkmanager.enable)
          "exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet"}
      '';
    };

    # Enable XDG desktop portal for screen sharing (standalone mode only)
    xdg.portal = mkIf config.my.isStandalone {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
