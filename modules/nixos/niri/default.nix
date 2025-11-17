{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.niri;
in {
  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  config = mkIf cfg.enable {
    # Binary cache configuration (like niri-flake)
    nix.settings = {
      substituters = [ "https://niri.cachix.org" ];
      trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
    };

    # System packages needed for niri
    environment.systemPackages = [
      pkgs.xdg-utils
      pkgs.xdg-desktop-portal-gnome
      pkgs.niri
    ];

    # Display manager integration
    services.displayManager.sessionPackages = [ pkgs.niri ];

    # Graphics support
    hardware.graphics.enable = lib.mkDefault true;

    # XDG configuration (like niri-flake)
    xdg = {
      autostart.enable = lib.mkDefault true;
      menus.enable = lib.mkDefault true;
      mime.enable = lib.mkDefault true;
      icons.enable = lib.mkDefault true;
      portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
        configPackages = [ pkgs.niri ];
      };
    };

    # Security and services (like niri-flake)
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # PAM for swaylock (like niri-flake)
    security.pam.services.swaylock = { };

    # System defaults (like niri-flake)
    programs.dconf.enable = lib.mkDefault true;
    fonts.enableDefaultPackages = lib.mkDefault true;

    # User systemd service for polkit agent (like niri-flake)
    systemd.user.services.niri-polkit = {
      description = "PolicyKit Authentication Agent for niri";
      wantedBy = [ "niri.service" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
