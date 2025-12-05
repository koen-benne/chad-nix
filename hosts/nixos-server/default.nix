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

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  # Auto garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Limit boot entries (important for /boot space)
  boot.loader.systemd-boot.configurationLimit = 5;

  # Auto-optimize nix store (deduplication)
  nix.optimise = {
    automatic = true;
    dates = ["03:45"]; # 3:45 AM daily
  };

  my.openssl.enable = true;
  # my.mc-servers.enable = true;
  my.theme.enable = true;

  # Enable the services you want
  my.homelab = {
    enable = true;
    # domain = "dorkoe.nl";  # Optional, this is the default
    # email = "koen.benne@gmail.com";  # Optional, this is the default

    nginx = {
      enable = true;
      mainSite.enable = true; # Optional: enable the main landing page
    };

    nextcloud = {
      enable = true;
      subdomain = "cloud"; # Optional, this is the default
      adminPassword = "PWD";
      dataDir = "/export/1tb/NextCloud/data"; # Optional, this is the default
    };
    jellyfin = {
      enable = true;
      subdomain = "jellyfin";
      mediaDir = "/mnt/biggidrive/jellyfin/";
    };
  };
}
