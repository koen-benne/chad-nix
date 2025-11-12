{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop";
  };
  options.networking.networkmanager = {
    enable = mkEnableOption "networkmanager";
  };
}