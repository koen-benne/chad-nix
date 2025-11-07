{lib, inputs, pkgs, config, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.sys.my.desktop = {
    enable = mkEnableOption "desktop";
  };
}
