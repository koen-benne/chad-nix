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
    enable = mkEnableOption (mdDoc "Enable lockscreen");
    autoLock = mkEnableOption (mdDoc "enable auto lock with hypridle");
  };
  config = mkIf cfg.enable {
    security.pam.services.hyprlock = {
      fprintAuth = false;
    };
  };
}
