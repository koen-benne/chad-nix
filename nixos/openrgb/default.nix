{ config, lib, pkgs, ... }:
let
  inherit (lib) mdDoc mkDefualt mkEnableOption mkIf mkMerge;
  cfg = config.my.openrgb;
in
{
  options.my.openrgb= {
    enable = mkEnableOption (mdDoc "openrgb");
  };

  config = mkIf cfg.enable {
    imports = [
      ./udev-rules.nix
    ];
    environment.systemPackages = with pkgs; [
      openrgb
      i2c-tools
    ];
  };
}
