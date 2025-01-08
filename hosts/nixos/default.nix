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

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
  boot.loader = {
    efi = {
      canTouchEfiVariables = lib.mkDefault true;
      efiSysMountPoint =
        lib.mkIf
        (builtins.hasAttr "/boot/efi" config.fileSystems
          && config.fileSystems."/boot/efi".fsType == "vfat")
        "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
    };
  };

  system.stateVersion = "23.11";

  networking.enableIPv6 = false;

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking = {
    hostName = "nixos";
    # usePredictableInterfaceNames = true;
    # defaultGateway = "192.168.0.1";
    # nameservers = ["8.8.8.8" "8.8.4.4"];
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

  # Stuff specific to only this machine
  my.gaming.enable = true;
  my.gaming.enableSunshine = true;
  my.virtualisation.enable = true;
  my.openssl.enable = true;
  my.bluetooth.enable = true;
}
