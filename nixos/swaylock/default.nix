{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.swaylock;
in
{
  options.my.swaylock = {
    enable = mkEnableOption (mdDoc "swaylock");
  };
  config = mkIf cfg.enable {
    hm.my.swaylock.enable = true;
    security.pam.services.swaylock = {
      fprintAuth = false;
    };
  };
}
