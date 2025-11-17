{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.niri;
in {
  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  config = mkIf cfg.enable {
    # Additional XDG desktop portal for niri
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}
