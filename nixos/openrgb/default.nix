{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkDefualt mkEnableOption mkIf mkMerge;
  cfg = config.my.openrgb;
in {
  imports = [
    ./udev-rules.nix
  ];
  options.my.openrgb = {
    enable = mkEnableOption (mdDoc "openrgb");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openrgb
      i2c-tools
    ];
  };
}
