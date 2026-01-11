{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.my.dankmaterialshell;
in {
  options.my.dankmaterialshell = {
    lockCommand = mkOption {
      type = types.str;
      default = "${pkgs.hyprlock}/bin/hyprlock";
      description = lib.mdDoc "Command to execute when locking the screen";
    };
  };

  config = mkIf cfg.enable {
    # Install and configure hyprlock
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          grace = 0;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "300, 60";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 2;
            placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
            shadow_passes = 2;
          }
        ];

        label = [
          # Time
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
            color = "rgb(202, 211, 245)";
            font_size = 120;
            font_family = "Inter Display";
            position = "0, -300";
            halign = "center";
            valign = "top";
          }
          # Date
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
            color = "rgb(202, 211, 245)";
            font_size = 25;
            font_family = "Inter Display";
            position = "0, -450";
            halign = "center";
            valign = "top";
          }
          # User
          {
            monitor = "";
            text = "  $USER";
            color = "rgb(202, 211, 245)";
            font_size = 18;
            font_family = "Inter Display";
            position = "0, -40";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # Override DMS lock command to use hyprlock
    programs.dankMaterialShell.settings = {
      customPowerActionLock = cfg.lockCommand;
    };
  };
}
