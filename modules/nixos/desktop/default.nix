# This is where I configure the entire desktop environment for linux systems in general
# There should not be anything in here that I don't want in every one of my linux systems with a desktop environment
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.desktop;
in {
  imports = [
    inputs.dms.nixosModules.greeter
  ];
  options.my.desktop = {
    windowManager = mkOption {
      type = types.enum ["hyprland" "niri" "mango"];
      default = "hyprland";
      description = mdDoc "Window manager to use";
    };
    greeter = mkOption {
      type = types.enum ["tuigreet" "dms"];
      default = "tuigreet";
      description = mdDoc "Greeter/login screen to use";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gparted
      xdg-desktop-portal-gtk
      xwayland
    ];

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    my.niri.enable = cfg.windowManager == "niri";
    my.hyprland.enable = cfg.windowManager == "hyprland";
    my.mango.enable = cfg.windowManager == "mango";
    my.theme.enable = true;

    hm.my.foot.enable = true;
    hm.my.thunderbird.enable = true;
    # hm.my.firefox.enable = true;
    hm.my.zen-browser.enable = true;
    hm.my.dankmaterialshell.enable = true;
    environment.sessionVariables = {
      NIXOS_OXONE_WL = "1";
    };

    services.dbus.enable = true;

    services.gvfs.enable = true;

    services.greetd = mkIf (cfg.greeter == "tuigreet") {
      enable = true;
      package = pkgs.unstable.greetd;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd ' ${
            if cfg.windowManager == "niri"
            then "niri-session"
            else if cfg.windowManager == "mango"
            then "mango"
            else "dbus-run-sesion Hyprland"
          }'";
        };
      };
    };

    # programs.dankMaterialShell.greeter = mkIf (cfg.greeter == "dankmaterialshell") {
    #   enable = true;
    #   compositor.name = cfg.windowManager;
    # };

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
