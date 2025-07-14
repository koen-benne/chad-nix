{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.tdarr-worker;
in {
  options.my.tdarr-worker = {
    enable = mkEnableOption (mdDoc "tdarr-worker");
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # AMD GPU support
    hardware.amdgpu.opencl.enable = true;

    # Tdarr Node container
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        tdarr-node = {
          image = "haveagitgat/tdarr_node:latest";
          autoStart = true;
          autoRemoveOnStop = false;
          volumes = [
            "/mnt/server-media:/media"
            "/tmp/tdarr-node:/temp"
          ];
          environment = {
            TZ = "Europe/Amsterdam";
            PUID = "0";
            PGID = "0";
            nodeID = "desktop-gpu-node";
            serverIP = "192.168.68.56";
            serverPort = "8266";
            nodeName = "Desktop-GPU-Node";
            UMASK_SET = "002";
            inContainer = "true";
            ffmpegVersion = "7";
            nodeType = "mapped";
            priority = "-1";
            cronPluginUpdate = "";
            apiKey = "";
            maxLogSizeMB = "10";
            pollInterval = "2000";
            startPaused = "false";
            transcodegpuWorkers = "4";
            transcodecpuWorkers = "6";
            healthcheckgpuWorkers = "2";
            healthcheckcpuWorkers = "2";
            LIBVA_DRIVER_NAME = "radeonsi";
          };
          extraOptions = [
            "--device=/dev/dri"
          ];
        };
      };
    };
    # Enable FUSE for SSHFS
    programs.fuse.userAllowOther = true;

    # Install SSHFS
    environment.systemPackages = with pkgs; [ sshfs ];

    fileSystems."/mnt/server-media" = {
      device = "${config.my.user}@192.168.68.56:/mnt/jellyfin/library";
      fsType = "sshfs";
      options = [
        "allow_other"
        "_netdev"
        "IdentityFile=${config.my.home}/.ssh/nixos"
        "StrictHostKeyChecking=no"
        "debug"          # Add SSHFS debugging
        "sshfs_debug"    # More SSHFS debugging
      ];
    };
    # Create temp directory
    systemd.tmpfiles.rules = [
      "d /tmp/tdarr-node 0755 root root -"
    ];
  };
}
