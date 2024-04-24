# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
# There should also not be anything in here that I would also like to have on my servers

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.desktop;
  wallpaper = ../../wp-1.png;
in
{
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # packages for my custom DE
      pavucontrol
      wl-clipboard
      dunst
      polkit
      # pinentry-gnome3
      gnome.nautilus
      evince
      gnome.eog
      libreoffice-qt
      mpv

      # MC shit
      prismlauncher
      jdk8

      # screenshotting
      grim
      slurp

      # other
      teams-for-linux
      figma-agent

      slack
      localsend
      ungoogled-chromium
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

    # See issue: https://github.com/nix-community/home-manager/issues/1213
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/mailto" = "thunderbird.desktop";
        "application/pdf" = "evince.desktop";
        "x-scheme-handler/figma" = "figma-linux.desktop";
      };
    };
  };
}
