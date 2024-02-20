{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.desktop;

in
{
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    # my.mpv.enable = true;
    home.activation.setWallpaper = hm.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/osascript -e '
        set desktopImage to POSIX file "/Users${config.my.user}/.config/chad-nix/wallpaper.jpg"
        tell application "Finder"
          set desktop picture to desktopImage
        end tell
      '
    '';
  };
}
