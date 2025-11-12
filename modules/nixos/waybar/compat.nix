{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.waybar = {
    enable = mkEnableOption "waybar";
  };
  options.networking.networkmanager = {
    enable = mkEnableOption "networkmanager";
  };
}