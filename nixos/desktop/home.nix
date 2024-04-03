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
      gnome.eog
      libreoffice-qt
      prismlauncher
      jdk8
      teams-for-linux
      grim
      slurp
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

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        # "x-scheme-handler/mailto" = "thunderbird.desktop";
        "application/pdf" = "evince.desktop";
      };
    };
  };
}
