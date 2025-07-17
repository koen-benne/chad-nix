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
  };
}
