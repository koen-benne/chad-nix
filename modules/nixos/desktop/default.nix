# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkDefualt mkEnableOption mkIf mkMerge;
  cfg = config.my.desktop;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gparted
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xwayland
    ];

    my.hyprland.enable = true;
    my.openrgb.enable = true;
    my.lockscreen.enable = true;
    my.theme.enable = true;
    my.uxplay.enable = true;
    hm.my.waybar.enable = true;
    hm.my.foot.enable = true;
    hm.my.thunderbird.enable = true;
    # hm.my.firefox.enable = true;
    hm.my.qutebrowser.enable = true;
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd 'dbus-run-session Hyprland'";
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
