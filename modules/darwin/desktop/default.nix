{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    windowManager = mkOption {
      type = types.enum ["yabai" "aerospace" "none"];
      default = "none";
      description = "window manager";
    };
    entries = mkOption {
      type = types.listOf types.attrs;
      default = [
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
      windowManager = cfg.windowManager;
    };

    # my.kitty.enable = true;
    hm.my.wezterm.enable = true;
    hm.my.theme.enable = true;

    my.dock = {
      enable = true;
      entries = cfg.entries;
    };
  };
}
