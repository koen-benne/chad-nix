{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.lockscreen;
in {
  options.my.lockscreen = {
    enable = mkEnableOption (mdDoc "lockscreen");
  };
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    };
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
  };
}
