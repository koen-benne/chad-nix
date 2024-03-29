# This is where I configure the entire desktop environment for linux systems

{ config, lib, pkgs, ... }:
let
  inherit (lib) mdDoc mkDefualt mkEnableOption mkIf mkMerge;
  cfg = config.my.desktop;
in
{
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xwayland
    ];

    hm.my.desktop.enable = true;

    my.hyprland.enable = true;
    my.openrgb.enable = true;
    my.swaylock.enable = true;
    my.theme.enable = true;
    hm.my.waybar.enable = true;

    environment.sessionVariables = {
      NIXOS_OXONE_WL = "1";
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    services.greetd = {
      enable = true;
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
    };
    security.rtkit.enable = true;
  };

}
