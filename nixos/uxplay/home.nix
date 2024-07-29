{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.uxplay;

  uxplayDesktopItem = pkgs.makeDesktopItem {
    name = "uxplay";
    desktopName = "UXplay";
    exec = "${pkgs.uxplay}/bin/uxplay -p";
    icon = "${pkgs.uxplay}/share/icons/hicolor/256x256/apps/uxplay.png";
    terminal = false;
    type = "Application";
  };
in {
  options.my.uxplay = {
    enable = mkEnableOption (mdDoc "uxplay");
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.uxplay
      uxplayDesktopItem
    ];
  };
}
