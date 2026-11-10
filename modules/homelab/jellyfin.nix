{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.jellyfin;
  homelabCfg = config.my.homelab;
in {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  options.my.homelab.jellyfin = {
    enable = mkEnableOption "Jellyfin media server via nixarr";

    subdomain = mkOption {
      type = types.str;
      default = "watch";
      description = "Subdomain for Jellyfin";
    };

    requestSubdomain = mkOption {
      type = types.str;
      default = "request";
      description = "Subdomain for Jellyseerr";
    };

    mediaDir = mkOption {
      type = types.path;
      default = "/mnt/biggidrive/jellyfin";
      description = "Root media directory";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/nixarr/.state";
      description = "Nixarr state directory";
    };

    transmissionPeerPort = mkOption {
      type = types.port;
      default = 50000;
      description = "Transmission peer port";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [
      opforjellyfin
    ];

    # Enable AMD graphics drivers and VA-API support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;  # For 32-bit app support
    };

    # Ensure the jellyfin user has access to GPU devices
    users.users.jellyfin = {
      extraGroups = [ "video" "render" ];
    };

    nixarr = {
      enable = true;
      mediaDir = cfg.mediaDir;
      stateDir = cfg.stateDir;

      # No VPN configuration
      vpn.enable = false;

      # Jellyfin with HTTPS
      jellyfin = {
        enable = true;
      };

      seerr = {
        enable = true;
      };

      # Download client (no VPN)
      # transmission = {
      #   enable = true;
      #   vpn.enable = false;
      #   peerPort = cfg.transmissionPeerPort;
      # };
      sabnzbd = {
        enable = true;
        whitelistRanges = [ "192.168.68.0/24" ];
        guiPort = 8080;
        openFirewall = true;
      };

      # Media management stack
      radarr.enable = true; # Movies
      radarr.openFirewall = true; # Movies

      sonarr.enable = true; # TV Shows
      sonarr.openFirewall = true; # TV Shows

      prowlarr.enable = true;
      prowlarr.openFirewall = true;

      recyclarr = {
        enable = true;

        schedule = "weekly";

        configuration = {
          radarr.movies = {
            base_url = "http://127.0.0.1:7878";
            api_key = "!env_var RADARR_API_KEY";

            include = [
              { template = "radarr-quality-definition-movie"; }
              { template = "radarr-quality-profile-hd-bluray-web"; }
              { template = "radarr-custom-formats-hd-bluray-web"; }
            ];
          };

          sonarr.series = {
            base_url = "http://127.0.0.1:8989";
            api_key = "!env_var SONARR_API_KEY";

            include = [
              { template = "sonarr-quality-definition-series"; }
              { template = "sonarr-v4-quality-profile-web-1080p"; }
              { template = "sonarr-v4-custom-formats-web-1080p"; }
            ];
          };
        };
      };

    };

    # sabnzbd's config file is read-only by default on this nixpkgs
    # version (system.stateVersion >= 26.05), and gets regenerated from
    # this declarative config on every service restart, so Usenet
    # server credentials and category setup can no longer be persisted
    # via the web UI wizard. They must be declared here instead. See:
    # https://github.com/nix-media-server/nixarr/pull/132
    sops.secrets.sabnzbd_servers_ini = {
      owner = "sabnzbd";
      group = "media";
      mode = "0400";
    };

    services.sabnzbd = {
      secretFiles = [ config.sops.secrets.sabnzbd_servers_ini.path ];

      settings.servers.easyusenet = {
        name = "easyusenet";
        displayname = "EasyUsenet";
        host = "reader.easyusenet.nl";
        port = 563;
        ssl = true;
        connections = 100;
      };

      settings.categories = {
        radarr = {
          dir = "${cfg.mediaDir}/usenet/radarr";
          pp = "3";
          script = "None";
          priority = "0";
        };
        sonarr = {
          dir = "${cfg.mediaDir}/usenet/sonarr";
          pp = "3";
          script = "None";
          priority = "0";
        };
        lidarr = {
          dir = "${cfg.mediaDir}/usenet/lidarr";
          pp = "3";
          script = "None";
          priority = "0";
        };
      };
    };

    my.homelab.spotweb.enable = true;

    # Deny jellyfin write acces as that is a terrible idea
    systemd.services.jellyfin.serviceConfig.ReadOnlyPaths = [
      "/mnt/biggidrive/jellyfin/library"
    ];

    # services.flaresolverr.enable = true;

    services.nginx.virtualHosts = mkIf config.my.homelab.nginx.enable {
      "${cfg.subdomain}.${homelabCfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
      "${cfg.requestSubdomain}.${homelabCfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          proxyWebsockets = true;
        };
      };
    };
  };
}
