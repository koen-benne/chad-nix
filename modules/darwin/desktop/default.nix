{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    hm.my.desktop.enable = true;
    my.dock = {
      enable = true;
      entries = [
        {path = "/Applications/Slack.app/";}
        {path = "/Applications/Brave Browser.app/";}
        {path = "${pkgs.kitty}/Applications/Kitty.app/";}
        {
          path = "${config.my.home}/Downloads";
          section = "others";
          options = "--sort name --view grid --display stack";
        }
      ];
    };
  };
}
