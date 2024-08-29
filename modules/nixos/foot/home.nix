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
    programs.foot.enable = true;
  };
}
