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
      settings = {
        show-user-name = true;
        show-date = true;
        show-seconds = true;
        show-indicators = true;
        indicator-radius = 10;
        indicator-thickness = 2;
        caps-lock-indicator-thickness = 2;
        caps-lock-indicator-radius = 10;
      };
    };
  };
}
