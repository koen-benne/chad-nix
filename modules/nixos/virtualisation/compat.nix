{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.virtualisation = {
    enable = mkEnableOption "virtualisation support";
  };
}