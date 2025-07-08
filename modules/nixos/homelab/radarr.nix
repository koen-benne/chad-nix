{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types mkDefault;
  cfg = config.my.homelab.radarr;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.radarr = {
    enable = mkEnableOption (mdDoc "Radarr movie management");

    subdomain = mkOption {
      type = types.str;
      default = "movies";
      description = mdDoc "Subdomain for Radarr web interface";
    };

    port = mkOption {
      type = types.port;
      default = 7878;
      description = mdDoc "Port for Radarr web interface";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/radarr";
      description = mdDoc "Data directory for Radarr";
    };

    moviesDir = mkOption {
      type = types.path;
      default = "/export/1tb/Media/Movies";
      description = mdDoc "Directory where movies will be organized";
    };

    downloadDir = mkOption {
      type = types.path;
      default = config.my.homelab.transmission.downloadDir or "/export/1tb/Media/Downloads";
      description = mdDoc "Directory where completed downloads are found";
    };

    autoEnableTransmission = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Automatically enable Transmission as download client";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Auto-enable Transmission unless explicitly disabled
    my.homelab.transmission.enable = mkIf cfg.autoEnableTransmission (mkDefault true);

    services.radarr = {
      enable = true;
      dataDir = cfg.dataDir;
    };

    # Create directories and set permissions
    system.activationScripts.radarr-setup = ''
      mkdir -p ${cfg.moviesDir}
      mkdir -p ${cfg.downloadDir}
      mkdir -p ${cfg.dataDir}
      
      # Radarr needs access to both movies directory (write) and downloads (read)
      chown -R radarr:radarr ${cfg.dataDir}
      
      # Allow radarr to read downloads and write to movies directory
      chmod -R 755 ${cfg.moviesDir}
      chmod -R 755 ${cfg.downloadDir}
      
      # Add radarr to transmission group for download access
      if getent group transmission > /dev/null 2>&1; then
        usermod -a -G transmission radarr 2>/dev/null || true
      fi
      
      # Allow radarr to write to movies directory
      if getent group radarr > /dev/null 2>&1; then
        chgrp -R radarr ${cfg.moviesDir} 2>/dev/null || true
        chmod -R g+w ${cfg.moviesDir} 2>/dev/null || true
      fi
    '';

    # Nginx proxy
    services.nginx.virtualHosts = mkIf config.my.homelab.nginx.enable {
      "${cfg.subdomain}.${homelabCfg.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_buffering off;
          '';
        };
      };
    };

    # Open firewall if needed (usually not needed with nginx proxy)
    networking.firewall.allowedTCPPorts = mkIf (!config.my.homelab.nginx.enable) [ cfg.port ];
  };
}
