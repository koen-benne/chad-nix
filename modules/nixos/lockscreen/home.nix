{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge mdDoc;
  cfg = config.my.lockscreen;
in {
  options.my.lockscreen = {
    enable = mkEnableOption (mdDoc "lockscreen");
    autoLock = mkEnableOption (mdDoc "enable auto lock with hypridle");
  };
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
