# TODO: move some of the firewall config here to their own files
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking = {
    hostName = "nixos-server";

    wireless.iwd = {
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    nameservers = ["8.8.8.8" "8.8.4.4"];

    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 53317]; # 53317 is for LocalSend

      allowedUDPPorts = [8211];
      allowedUDPPortRanges = [
        {
          from = 4000;
          to = 4007;
        }
        {
          from = 53315;
          to = 53318;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };

  services.xserver.enable = false;

  systemd.targets.sleep.enable = false;

  boot.kernelParams = ["consoleblank=120"];

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      HandleLidSwitch=ignore
      HandleLidSwitchDocked=ignore
      HandleLidSwitchExternalPower=ignore
    '';
  };

  my.openssl.enable = true;
  # my.mc-servers.enable = true;
  my.homelab.enable = true;
  my.theme.enable = true;
}
