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
  };
}
