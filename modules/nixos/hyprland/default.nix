{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.hyprland;
in {
  options.my.hyprland = {
    enable = mkEnableOption (mdDoc "hyprland");
  };

  config = mkIf cfg.enable {
    hm.my.hyprland.enable = true;

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
    };
  };
}
