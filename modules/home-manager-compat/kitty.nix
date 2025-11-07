{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.kitty = {
    enable = mkEnableOption "kitty terminal emulator";
  };
}