{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.uxplay = {
    enable = mkEnableOption "uxplay AirPlay server";
  };
}