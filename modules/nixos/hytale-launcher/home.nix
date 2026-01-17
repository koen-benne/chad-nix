{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.hytale-launcher;
in {
  options.my.hytale-launcher = {
    enable = mkEnableOption (mdDoc "hytale-launcher");
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
