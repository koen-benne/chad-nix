{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.mango;
in {
  options.my.mango = {
    enable = mkEnableOption "mango scrollable-tiling wayland compositor";
  };

  imports = [
    inputs.mango.nixosModules.mango
  ];

  config = mkIf cfg.enable {
    programs.mango.enable = true;
  };
}
