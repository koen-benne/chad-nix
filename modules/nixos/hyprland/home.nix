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

  # Helper functions for conditional nixGL wrapping
  wrapCmd = cmd: lib.my.wrapGL config cmd;
in {
  config = mkIf (sys.my.hyprland.enable or config.my.hyprland.enable) {
    # Enable DMS for both NixOS and standalone mode
    my.dankmaterialshell.enable = true;

    # Screenshot tools for Hyprland
    home.packages = with pkgs; [
      grim
      slurp
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      extraConfig = ''
        ${sharedConfig {inherit scripts wrapCmd;}}
      '';
    };
  };
}
