{
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.my.niri = {
    enable = mkEnableOption "niri window manager";
  };
}