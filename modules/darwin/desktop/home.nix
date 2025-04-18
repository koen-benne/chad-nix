# Stuff specific to a desktop version of darwin
# This structure is goddamn terrible lmao
# Works for now ig
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  wallpaper = ../../../assets/wp-normal.jpg;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
    windowManager = mkOption {
      type = types.enum ["aerospace" "none"];
      default = "none";
      description = "window manager";
    };
  };

  config = mkIf cfg.enable {
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
