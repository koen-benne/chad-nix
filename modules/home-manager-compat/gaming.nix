{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.gaming = {
    enable = mkEnableOption "gaming";
    enableSunshine = mkEnableOption "sunshine streaming";
  };
}