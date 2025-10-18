{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkMerge;
  cfg = config.my.gaming;
in {
  options.my.gaming = {
    enable = mkEnableOption (mdDoc "gaming");
    enableSunshine = mkEnableOption (mdDoc "sunshine");
  };

  imports = [
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
    inputs.chaotic.nixosModules.nyx-registry
  ];

  config = mkMerge [
    {
      # We can never have overlays that are not in parts/overlays.nix (read-only)
      chaotic.nyx.overlay.enable = false;
    }
    (mkIf cfg.enable {
      boot.kernelPackages = pkgs.linuxPackages_zen;

      hm.my.gaming.enable = true;

      environment.systemPackages = with pkgs; [
        steamcmd
        mangohud
        xdg-user-dirs
        protonup-qt

        steamtinkerlaunch
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
        # In case i want to use mesa-git. This tends to be a bad idea when not on unstable
        # package = pkgs.mesa_git;
        # package32 = pkgs.mesa32_git;
      };

      hardware.steam-hardware.enable = true;

      services.sunshine = mkIf cfg.enableSunshine {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
        # Currently, it is necessary to run 'sudo setfacl -m g:input:rw /dev/uhid' to get ds5 emu to work.
        # Seems like https://github.com/LizardByte/Sunshine/pull/2906 should fix this issue.
        settings = {
          gamepad = "ds5";
        };
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
                  do = ''${pkgs.bash}/bin/bash -c "${pkgs.hyprland}/bin/hyprctl keyword monitor \"DP-3,''${SUNSHINE_CLIENT_WIDTH}x''${SUNSHINE_CLIENT_HEIGHT}@''${SUNSHINE_CLIENT_FPS},0x0,1\""'';
                  undo = "${pkgs.hyprland}/bin/hyprctl keyword monitor DP-3,3440x1440@159.96201,0x0,1";
                }
              ];
            }
          ];
        };
      };
    })
  ];
}
