{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.foot;
in {
  options.my.foot = {
    enable = mkEnableOption "foot";
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
