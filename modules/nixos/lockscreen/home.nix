{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  cfg = sys.my.lockscreen;
in {
  config = mkIf cfg.enable (mkMerge [
    # Always enable hyprlock
    {
      programs.hyprlock = {
        enable = true;
      };
    }

    # Only enable hypridle if autoLock is enabled
    (mkIf cfg.autoLock {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "hyprlock";
            before_sleep_cmd = "hyprlock";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "hyprlock";
            }
            {
              timeout = 600;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 900;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
    })
  ]);
}
