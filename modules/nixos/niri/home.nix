{
  config,
  lib,
  pkgs,
  inputs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.niri;
in {
  config = mkIf cfg.enable {
    # Create DMS directory for dynamic config files
    xdg.configFile."niri/dms/.keep".text = "";

    # Disable niri-flake's config file management but keep the program enabled
    programs.niri.config = lib.mkForce null;

    # Manage the config file ourselves with DMS includes
    # We use a template to substitute store paths
    xdg.configFile."niri/config.kdl".text = builtins.readFile (
      pkgs.replaceVars ./config.kdl {
        xwayland_satellite_path = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite";
      }
    );
  };
}
