{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.syncthing;
in {
  options.my.tdarr-worker = {
    enable = mkEnableOption (mdDoc "tdarr-worker");
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # AMD GPU support
    hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };

    # Tdarr Node container
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        tdarr-node = {
          image = "haveagitgat/tdarr-node:latest";
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
          };
          extraOptions = [
            "--device=/dev/dri"
          ];
        };
      };
    };

    # Mount server media via NFS/SMB
    fileSystems."/mnt/server-media" = {
      device = "your-server-ip:/mnt/jellyfin/library";
      fsType = "nfs";
      options = [ "rw" "hard" "intr" ];
    };
  };
}
