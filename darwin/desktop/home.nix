# Stuff specific to a desktop version of darwin
# This structure is goddamn terrible lmao
# Works for now ig
{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  wallpaper = ../../wallpaper.jpg;
  cfg = config.my.desktop;

in
{
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    # my.mpv.enable = true;
    my.alacritty.enable = true;

    home.activation.setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
