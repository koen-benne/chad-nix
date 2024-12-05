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
  };
  config = mkIf cfg.enable {
    hm.my.lockscreen.enable = true;
    security.pam.services.hyprlock = {
      fprintAuth = false;
    };
  };
}
