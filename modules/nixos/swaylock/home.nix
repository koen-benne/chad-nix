{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.swaylock;
in {
  options.my.swaylock = {
    enable = mkEnableOption (mdDoc "swaylock");
  };
  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        screenshots = true;
        clock = true;
        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 7;
        effect-blur = "7x5";
        ring-color = "00000033";
        key-hl-color = "ffffff";
        line-color = "00000000";
        inside-color = "00000000";
        separator-color = "00000000";
        grace = 2;
        fade-in = 0.2;
      };
    };
  };
}
