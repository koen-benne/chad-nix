{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.theme = {
    enable = mkEnableOption "system theme configuration";
  };
}