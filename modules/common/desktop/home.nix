{
  lib,
  sys,
  pkgs,
  ...
}: {
  config = lib.mkIf sys.my.desktop.enable {
    home.packages = with pkgs; [
      unstable.vesktop
      ripasso-cursive
      spotify-player
      # freetube
    ];

    my.zen-browser.enable = true;
  };
}
