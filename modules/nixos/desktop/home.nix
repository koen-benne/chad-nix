# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
# There should also not be anything in here that I would also like to have on my servers
{
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf optionals;
in {
  config = mkIf sys.my.desktop.enable {
    home.packages = with pkgs;
      [
        # controlls stuff
        playerctl
        pavucontrol
        helvum

        # packages for my custom DE
        nwg-displays
        obs-studio
        wl-clipboard
        dunst
        hyprpicker
        nautilus
        evince
        eog
        libreoffice-qt
        mpv
        qbittorrent
        obsidian
        alsa-scarlett-gui



        # other
        # teams-for-linux
        # figma-agent

        # slack
        localsend
        ungoogled-chromium
        unstable._1password-gui
      ];


    # See issue: https://github.com/nix-community/home-manager/issues/1213
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "evince.desktop";
        "x-scheme-handler/figma" = "figma-linux.desktop";
        "x-scheme-handler/teams" = "teams-for-linux.desktop";
      };
    };
  };
}
