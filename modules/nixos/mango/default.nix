{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.mango;
in {
  options.my.mango = {
    enable = mkEnableOption (mdDoc "mango scrollable-tiling wayland compositor");
  };

  imports = [
    inputs.mango.nixosModules.mango
  ];

  config = mkIf cfg.enable {
    programs.mango.enable = true;
  };
}
