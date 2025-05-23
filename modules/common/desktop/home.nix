{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.my.desktop;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # openASAR
      unstable.vesktop
      ripasso-cursive
      # freetube
    ];
  };
}
