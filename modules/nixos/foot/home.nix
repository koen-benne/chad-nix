{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.foot;
in {
  options.my.foot = {
    enable = mkEnableOption (mdDoc "foot");
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMonoNL Nerd Font:size=15";
        };
        colors = {
          alpha = 0.6;
          background = "000408";
          foreground = "ffffff";
        };
      };
    };
  };
}
