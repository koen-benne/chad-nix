{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.desktop;
  wallpaper = ../../wallpaper.jpg;
in
{
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      polkit
      wl-clipboard
      pinentry-gnome
      dunst
      pavucontrol
      gnome.nautilus
      evince
      libreoffice-qt
      prismlauncher
    ];

    programs.fuzzel = {
      enable = true;
    };

    programs.wpaperd = {
      enable = true;
      settings = {
        default = { path = wallpaper; };
      };
    };
  };
}
