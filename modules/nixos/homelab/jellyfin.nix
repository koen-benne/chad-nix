{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.jellyfin;
  homelabCfg = config.my.homelab;
in {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  options.my.homelab.jellyfin = {
    enable = mkEnableOption (mdDoc "Jellyfin media server via nixarr");

    subdomain = mkOption {
      type = types.str;
      default = "watch";
      description = mdDoc "Subdomain for Jellyfin";
    };

    mediaDir = mkOption {
      type = types.path;
      default = "/mnt/jellyfin";
      description = mdDoc "Root media directory";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/mnt/jellyfin/.state/nixarr";
      description = mdDoc "Nixarr state directory";
    };

    transmissionPeerPort = mkOption {
      type = types.port;
      default = 50000;
      description = mdDoc "Transmission peer port";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    nixarr = {
      enable = true;
      mediaDir = cfg.mediaDir;
      stateDir = cfg.stateDir;

      # No VPN configuration
      vpn.enable = false;

      # Jellyfin with HTTPS
      jellyfin = {
        enable = true;
        expose.https = {
          enable = config.my.homelab.nginx.enable;
          domainName = "${cfg.subdomain}.${homelabCfg.domain}";
          acmeMail = homelabCfg.email;
        };
      };

      # Download client (no VPN)
      transmission = {
        enable = true;
        vpn.enable = false;
        peerPort = cfg.transmissionPeerPort;
      };
      sabnzbd.enable = true;

      # Media management stack
      bazarr.enable = true;      # Subtitles
      prowlarr.enable = true;    # Indexer management
      radarr.enable = true;      # Movies
      sonarr.enable = true;      # TV Shows
      jellyseerr.enable = true;  # User requests
    };

    services.flaresolverr.enable = true;

    virtualisation.docker.enable = true;
    users.users.${config.my.user}.extraGroups = [ "docker" ];

    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/jellyfin/library 192.168.68.56/24(rw,sync,no_subtree_check,no_root_squash,vers=4)
      '';
    };

    # Create persistent directories
    systemd.tmpfiles.rules = [
      "d /etc/tdarr/configs 0755 root root"
      "d /etc/tdarr/logs 0755 root root"
    ];# Declarative container management
    virtualisation.oci-containers = {
      backend = "docker";
      containers = {
        tdarr = {
          image = "haveagitgat/tdarr:latest";
          autoStart = true;
          autoRemoveOnStop = false;
          ports = [
            "8265:8265"
            "8266:8266"
          ];
          volumes = [
            "/mnt/jellyfin/library:/media"
            "/etc/tdarr/configs:/app/configs"
            "/etc/tdarr/logs:/app/logs"
            "/tmp/tdarr-temp:/temp"
          ];
          environment = {
            TZ = "Europe/Amsterdam";
            PUID = "0";
            PGID = "0";
          };
          extraOptions = [
            "--restart=unless-stopped"
          ];
        };
      };
    };
  };
}
