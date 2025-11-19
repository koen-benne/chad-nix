{
  config,
  lib,
  pkgs,
  inputs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.mango;
  scripts = ./scripts;

  # Import shared config
  sharedConfig = import ./config.nix;

  # Helper function to conditionally wrap commands with nixGL for standalone mode
  wrapCmd = cmd: lib.my.wrapGL config cmd;
in {
  config = mkIf cfg.enable {
    # Polkit agent package for both NixOS and standalone modes
    home.packages = [
      pkgs.polkit_gnome
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = sharedConfig {inherit scripts wrapCmd;};
      autostart_sh = ''
        wl-paste --watch cliphist store &
        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        ${wrapCmd "foot --server"} &
        # see autostart.sh
        # Note: here no need to add shebang
      '';
    };
  };
}
