{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkForce;
  cfg = config.my.theme;
  swaylockEnable = config.programs.swaylock.enable;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  config = mkIf cfg.enable {
    stylix = {
      targets = {
        neovim.enable = false;
        waybar.enable = false;
        fuzzel.enable = false;
      };
      opacity = {
        popups = 0.8;
        terminal = 0.6;
      };
    };

    programs.swaylock.settings = mkIf swaylockEnable {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      line-color = "00000000";
      separator-color = "00000000";
      grace = 2;
      fade-in = 0.2;
    };
  };
}
