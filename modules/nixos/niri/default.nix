{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkDefault mkForce;
  cfg = config.my.niri;
in {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  config = lib.mkMerge [
    # When disabled, forcefully disable programs.niri and prevent config generation
    (mkIf (!cfg.enable) {
      programs.niri.package = mkDefault pkgs.emptyDirectory;
      hm.programs.niri.settings = mkForce null;
      hm.programs.niri.config = mkForce null;
    })
    (mkIf cfg.enable {
      programs.niri.enable = true;
      # Use niri-unstable for optional includes support
      programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    })
  ];
}
