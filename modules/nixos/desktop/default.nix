# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    windowManager = mkOption {
      type = types.enum ["hyprland" "niri"];
      default = "hyprland";
      description = mdDoc "Window manager to use";
    };
    panelStyle = mkOption {
      type = types.enum ["waybar" "dankmaterialshell"];
      default = "waybar";
      description = mdDoc "Panel/bar style to use";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gparted
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xwayland
    ];

    my.hyprland.enable = cfg.windowManager == "hyprland";
    my.niri.enable = cfg.windowManager == "niri";
    my.lockscreen.enable = true;
    my.theme.enable = true;
    my.uxplay.enable = true;

    hm.my.foot.enable = true;
    hm.my.thunderbird.enable = true;
    # hm.my.firefox.enable = true;
    hm.my.qutebrowser.enable = true;
    hm.my.waybar.enable = cfg.panelStyle == "waybar";
    hm.my.dankmaterialshell.enable = cfg.panelStyle == "dankmaterialshell";
    environment.sessionVariables = {
      NIXOS_OXONE_WL = "1";
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    services.gvfs.enable = true;

    services.greetd = {
      enable = true;
      package = pkgs.unstable.greetd;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd 'dbus-run-session ${
            if cfg.windowManager == "niri"
            then "niri-session"
            else "Hyprland"
          }'";
        };
      };
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    security.rtkit.enable = true;
    security.polkit.enable = true;
  };
}
