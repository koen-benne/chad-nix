{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
  };
}