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
in {
  imports = [
    inputs.mango.hmModules.mango
  ];

  config = mkIf cfg.enable {
    # Polkit agent package for both NixOS and standalone modes
    home.packages = [
      pkgs.polkit_gnome
    ];

    wayland.windowManager.mango = {
      enable = true;
      settings = sharedConfig {inherit scripts;};
      autostart_sh = ''
        wl-paste --watch cliphist store &
        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
        foot --server &
        dms run &
        # see autostart.sh
        # Note: here no need to add shebang
      '';
    };
  };
}
