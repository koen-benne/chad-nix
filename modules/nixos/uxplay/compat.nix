{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.uxplay = {
    enable = mkEnableOption "uxplay AirPlay server";
  };
}