{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.librewolf;
in
{
  options.my.librewolf = {
    enable = mkEnableOption (mdDoc "librewolf");
  };
  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
