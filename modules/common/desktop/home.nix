{
  lib,
  sys,
  pkgs,
  ...
}: {
  config = lib.mkIf sys.desktop.enable {
    home.packages = with pkgs; [
      unstable.vesktop
      ripasso-cursive
      spotify-player
      # freetube
    ];
  };
}
