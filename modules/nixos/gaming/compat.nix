{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.gaming = {
    enable = mkEnableOption "gaming";
    enableSunshine = mkEnableOption "sunshine streaming";
  };
}