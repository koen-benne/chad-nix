{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.theme = {
    enable = mkEnableOption "system theme configuration";
  };
}