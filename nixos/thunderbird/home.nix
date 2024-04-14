{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.thunderbird;
in
{
  options.my.thunderbird = {
    enable = mkEnableOption (mdDoc "thunderbird");
  };
  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
    };
  };
}
