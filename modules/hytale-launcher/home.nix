{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.hytale-launcher;
in {
  options.my.hytale-launcher = {
    enable = mkEnableOption "hytale-launcher";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
