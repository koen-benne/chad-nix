{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types mkDefault;
  cfg = config.my.homelab.sonarr;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.sonarr = {
    enable = mkEnableOption (mdDoc "Sonarr TV series management");

    subdomain = mkOption {
      type = types.str;
      default = "shows";
      description = mdDoc "Subdomain for Sonarr web interface";
    };

    port = mkOption {
      type = types.port;
      default = 8989;
      description = mdDoc "Port for Sonarr web interface";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/sonarr";
      description = mdDoc "Data directory for Sonarr";
    };

    tvDir = mkOption {
      type = types.path;
      default = "/export/1tb/Media/TV";
      description = mdDoc "Directory where TV shows will be organized";
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

    services.sonarr = {
      enable = true;
      dataDir = cfg.dataDir;
    };

    # Create directories and set permissions
    system.activationScripts.sonarr-setup = ''
      mkdir -p ${cfg.tvDir}
      mkdir -p ${cfg.downloadDir}
      mkdir -p ${cfg.dataDir}
      
      # Sonarr needs access to both TV directory (write) and downloads (read)
      chown -R sonarr:sonarr ${cfg.dataDir}
      
      # Allow sonarr to read downloads and write to TV directory
      chmod -R 755 ${cfg.tvDir}
      chmod -R 755 ${cfg.downloadDir}
      
      # Add sonarr to transmission group for download access
      if getent group transmission > /dev/null 2>&1; then
        usermod -a -G transmission sonarr 2>/dev/null || true
      fi
      
      # Allow sonarr to write to TV directory
      if getent group sonarr > /dev/null 2>&1; then
        chgrp -R sonarr ${cfg.tvDir} 2>/dev/null || true
        chmod -R g+w ${cfg.tvDir} 2>/dev/null || true
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
