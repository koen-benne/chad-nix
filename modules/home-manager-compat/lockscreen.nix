{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.lockscreen = {
    enable = mkEnableOption "lockscreen";
    autoLock = mkEnableOption "auto lock with hypridle";
  };
}