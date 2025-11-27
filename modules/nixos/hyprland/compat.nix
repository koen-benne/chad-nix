{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.hyprland;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    # XDG desktop portal for standalone home-manager mode
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };

    # Hyprland-specific packages for standalone mode
    home.packages = [
      pkgs.hyprpolkitagent
      pkgs.grim
      pkgs.slurp
    ];
  };
}
