{
  config,
  pkgs,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.gaming;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      # MC shit
      prismlauncher
      unstable.vintagestory
      jdk8
    ];
  };
}
