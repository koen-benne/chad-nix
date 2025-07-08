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

      # Media management stack
      bazarr.enable = true;      # Subtitles
      prowlarr.enable = true;    # Indexer management
      radarr.enable = true;      # Movies
      sonarr.enable = true;      # TV Shows
      jellyseerr.enable = true;  # User requests
    };

    services.flaresolverr.enable = true;
  };
}
