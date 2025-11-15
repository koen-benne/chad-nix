{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.opencode = {
    enable = mkEnableOption "opencode";
  };
}