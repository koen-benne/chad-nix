{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.unmanic;
in {
  options.my.unmanic = {
    enable = mkEnableOption (mdDoc "unmanic");
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # AMD GPU support
    hardware.amdgpu.opencl.enable = true;
    hardware.graphics.extraPackages = [ pkgs.amf ];

    # Enable FUSE for SSHFS
    programs.fuse.userAllowOther = true;

    environment.systemPackages = with pkgs; [
      sshfs
      python3Packages.unmanic
    ];

    fileSystems."/mnt/server-media" = {
      device = "root@192.168.68.56:/mnt/jellyfin/library";
      fsType = "sshfs";
      options = [
        "allow_other"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.device-timeout=30"
        "IdentityFile=${config.my.home}/.ssh/nixos"
        "StrictHostKeyChecking=no"
        "reconnect"
      ];
    };

    # Create unmanic user
    users.users.unmanic = {
      isSystemUser = true;
      group = "unmanic";
      home = "/var/lib/unmanic";
      createHome = true;
      description = "Unmanic service user";
    };

    users.groups.unmanic = {};

    # Create the systemd service
    systemd.services.unmanic = {
      description = "Unmanic - Library Optimiser";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "unmanic";
        Group = "unmanic";
        WorkingDirectory = "/var/lib/unmanic";
        ExecStart = "${pkgs.python3Packages.unmanic}/bin/unmanic";
        Restart = "always";
        RestartSec = "30";
        StartLimitInterval = "200";
        StartLimitBurst = "3";

        # Security hardening
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/var/lib/unmanic" "/mnt/server-media" ];
        NoNewPrivileges = true;
      };

      environment = {
        HOME = "/var/lib/unmanic";
      };
    };

    # Ensure the service starts automatically
    systemd.targets.multi-user.wants = [ "unmanic.service" ];
  };
}
