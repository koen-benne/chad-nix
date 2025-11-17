{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.niri;
in {
  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gnome
    ];

    # Polkit authentication agent
    security.polkit.enable = true;

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };
}
