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
      unstable.vesktop
      ripasso-cursive
      spotify-player
      # freetube
    ];
  };
}
