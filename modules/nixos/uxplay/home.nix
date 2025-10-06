{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.uxplay;

  uxplayDesktopItem = pkgs.makeDesktopItem {
    name = "uxplay";
    desktopName = "UXplay";
    exec = "${pkgs.uxplay}/bin/uxplay -p";
    icon = "${pkgs.uxplay}/share/icons/hicolor/256x256/apps/uxplay.png";
    terminal = false;
    type = "Application";
  };
in {
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.uxplay
      uxplayDesktopItem
    ];
  };
}
