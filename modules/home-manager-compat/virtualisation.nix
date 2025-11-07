{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.virtualisation = {
    enable = mkEnableOption "virtualisation support";
  };
}