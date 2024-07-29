{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkDefualt mkEnableOption mkIf mkMerge;
  cfg = config.my.hyprland;
in {
  options.my.hyprland = {
    enable = mkEnableOption (mdDoc "hyprland");
  };

  config = mkIf cfg.enable {
    hm.my.hyprland.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}
