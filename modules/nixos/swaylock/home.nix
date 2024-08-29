{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.swaylock;
in {
  options.my.swaylock = {
    enable = mkEnableOption (mdDoc "swaylock");
  };
  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
    };
  };
}
