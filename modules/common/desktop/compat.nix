{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop";
  };
}