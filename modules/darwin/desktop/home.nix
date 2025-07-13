# Stuff specific to a desktop version of darwin
# This structure is goddamn terrible lmao
# Works for now ig
{
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  wallpaper = ../../../assets/wp-normal.jpg;
in {
  config = mkIf sys.desktop.enable {
    # my.mpv.enable = true;
    home.activation.setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/osascript -e '
        set desktopImage to POSIX file "${wallpaper}"
        tell application "Finder"
          set desktop picture to desktopImage
        end tell
      '
    '';

    home.file.".hushlogin".text = "";
  };
}
