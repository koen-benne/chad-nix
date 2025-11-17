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
  wrapCmd = cmd: if config.my.isStandalone then "nixGLIntel ${cmd}" else cmd;
in {
  config = mkIf (sys.my.hyprland.enable or config.my.hyprland.enable) {
    # Enable DMS for both NixOS and standalone mode
    my.dankmaterialshell.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      extraConfig = ''
        ${sharedConfig { inherit scripts wrapCmd; }}
      '';
    };
  };
}
