{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    hm.my.desktop.enable = true;

    hm.my.spicetify.enable = true;
  };
}