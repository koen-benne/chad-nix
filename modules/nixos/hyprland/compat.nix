{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.my.hyprland;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
    nixgl = {
      variant = mkOption {
        type = types.enum ["auto" "intel" "nvidia" "mesa"];
        default = "intel";
        description = "Which NixGL variant to use for standalone home-manager. Intel variant avoids nvidia impurities.";
      };
    };
  };

  config = mkIf cfg.enable {
    # XDG desktop portal for standalone home-manager mode
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    # Hyprland-specific packages for standalone mode
    home.packages = [
      pkgs.hyprpolkitagent
    ];
  };
}