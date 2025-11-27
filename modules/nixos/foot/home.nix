{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.foot;
in {
  options.my.foot = {
    enable = mkEnableOption (mdDoc "foot");
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      package = pkgs.foot;
      settings.main = {
        pad = "0x0 center";
      };
    };
  };
}
