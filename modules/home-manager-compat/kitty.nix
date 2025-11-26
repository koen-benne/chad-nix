{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.kitty = {
    enable = mkEnableOption "kitty terminal emulator";
  };
}
