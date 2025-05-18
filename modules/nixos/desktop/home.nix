# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
# There should also not be anything in here that I would also like to have on my servers
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # sound
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

      # screenshotting
      grim
      slurp

      # other
      teams-for-linux
      # figma-agent

      slack
      localsend
      ungoogled-chromium
      unstable._1password-gui
    ] ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];

    programs.fuzzel = {
      enable = true;
    };

    # See issue: https://github.com/nix-community/home-manager/issues/1213
    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/mailto" = "thunderbird.desktop";
        "application/pdf" = "evince.desktop";
        "x-scheme-handler/figma" = "figma-linux.desktop";
      };
    };
  };
}
