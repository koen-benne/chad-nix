{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.hyprland = {
    enable = mkEnableOption "hyprland window manager";
  };
}