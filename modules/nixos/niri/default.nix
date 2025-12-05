{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkDefault;
  cfg = config.my.niri;
in {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  config = lib.mkMerge [
    # Override the default package to prevent evaluating niri when disabled
    # The niri flake module sets a default that always evaluates the niri package
    {
      programs.niri.package = mkDefault pkgs.emptyDirectory;
    }
    (mkIf cfg.enable {
      programs.niri.enable = true;
      # Set the actual niri package when enabled
      programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;
    })
  ];
}
