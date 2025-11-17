{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.openssl = {
    enable = mkEnableOption "openssl configuration";
  };
}