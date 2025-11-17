{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.niri;
in {
  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  imports = [
    inputs.niri.nixosModules.niri
  ];
}
