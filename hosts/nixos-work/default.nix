{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  hardware.asahi.useExperimentalGPUDriver = true;

  system.stateVersion = "25.11"; # Did you read the comment?

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking = {
    wireless.iwd = {
      enable = true;
      settings.Settings.AutoConnect = true;
    };
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    hostName = "nixos-work";
    # usePredictableInterfaceNames = true;
    # defaultGateway = "192.168.0.1";
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

  # Everythhing desktop related
  my.desktop.enable = true;
  hm.my.spicetify.enable = false;

  # Stuff specific to only this machine
  my.openssl.enable = true;
  my.bluetooth.enable = true;
  my.android.enable = true;
  my.corectrl.enable = true;

}

