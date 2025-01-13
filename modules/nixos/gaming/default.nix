{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.gaming;
in {
  options.my.gaming = {
    enable = mkEnableOption (mdDoc "gaming");
    enableSunshine = mkEnableOption (mdDoc "sunshine");
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ pkgs.steam-run-native ];

    environment.systemPackages = with pkgs; [
      steamcmd
      xdg-user-dirs
      protonup-qt
    ];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.steam-hardware.enable = true;

    services.sunshine = mkIf cfg.enableSunshine {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications = {
        env = {
            PATH = "$(PATH):$(HOME)\/.local\/bin";
        };
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            detached = [
              "${pkgs.util-linux}/bin/setsid ${pkgs.steam}/bin/steam steam:\/\/open\/gamepadui"
            ];
            image-path = "steam.png";
            exclude-global-prep-cmd = "";
            auto-detach = "true";
            wait-all = "true";
            exit-timeout = "5";
            prep-cmd = [
              {
                do = ''${pkgs.hyprland}/bin/hyprctl keyword monitor "DP-3,''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS},0x0,1"'';
                undo = "${pkgs.hyprland}/bin/hyprctl keyword monitor DP-3,3440x1440@159.96201,0x0,1";
              }
            ];
          }
        ];
      };
    };
  };
}
