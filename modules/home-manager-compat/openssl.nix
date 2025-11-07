{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.openssl = {
    enable = mkEnableOption "openssl configuration";
  };
}