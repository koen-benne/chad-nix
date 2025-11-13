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
  # imports = [
  #   inputs.niri.nixosModules.niri
  # ];

  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  # config = mkIf cfg.enable {
  #   programs.niri.enable = true;
  # };
}
