{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
    windowManager = mkOption {
      type = types.enum ["yabai" "aerospace" "none"];
      default = "none";
      description = "window manager";
    };
    entries = mkOption {
      type = types.listOf types.attrs;
      default = [
        {path = "/Applications/Slack.app/";}
        {path = "/Applications/Brave Browser.app/";}
        {path = "${pkgs.kitty}/Applications/Kitty.app/";}
        {
          path = "${config.my.home}/Downloads";
          section = "others";
          options = "--sort name --view grid --display stack";
        }
      ];
      description = "desktop entries";
    };
  };

  config = mkIf cfg.enable {
    hm.my.desktop = {
      enable = true;
      windowManager = cfg.windowManager;
    };

    # my.kitty.enable = true;
    hm.my.wezterm.enable = true;

    my.dock = {
      enable = true;
      entries = cfg.entries;
    };
  };
}
