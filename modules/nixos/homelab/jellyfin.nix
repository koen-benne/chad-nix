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

    requestSubdomain = mkOption {
      type = types.str;
      default = "request";
      description = mdDoc "Subdomain for Jellyseerr";
    };

    mediaDir = mkOption {
      type = types.path;
      default = "/mnt/biggidrive/jellyfin";
      description = mdDoc "Root media directory";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/nixarr/.state";
      description = mdDoc "Nixarr state directory";
    };

    transmissionPeerPort = mkOption {
      type = types.port;
      default = 50000;
      description = mdDoc "Transmission peer port";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [
      opforjellyfin
    ];
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

      jellyseerr = {
        enable = true;
        expose.https = {
          enable = config.my.homelab.nginx.enable;
          domainName = "${cfg.requestSubdomain}.${homelabCfg.domain}";
          acmeMail = homelabCfg.email;
        };
      };

      # Download client (no VPN)
      # transmission = {
      #   enable = true;
      #   vpn.enable = false;
      #   peerPort = cfg.transmissionPeerPort;
      # };
      sabnzbd.enable = true;

      # Media management stack
      radarr.enable = true; # Movies
      sonarr.enable = true; # TV Shows
    };

    # Deny jellyfin write acces as that is a terrible idea
    systemd.services.jellyfin.serviceConfig.ReadOnlyPaths = [
      "/mnt/biggidrive/jellyfin/library"
    ];

    # services.flaresolverr.enable = true;
  };
}
