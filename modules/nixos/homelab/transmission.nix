{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.transmission;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.transmission = {
    enable = mkEnableOption (mdDoc "Transmission BitTorrent client");

    subdomain = mkOption {
      type = types.str;
      default = "transmission";
      description = mdDoc "Subdomain for Transmission web interface";
    };

    port = mkOption {
      type = types.port;
      default = 9091;
      description = mdDoc "Port for Transmission web interface";
    };

    downloadDir = mkOption {
      type = types.path;
      default = "/export/1tb/Media/Downloads";
      description = mdDoc "Directory for completed downloads";
    };

    incompleteDir = mkOption {
      type = types.path;
      default = "/export/1tb/Media/Incomplete";
      description = mdDoc "Directory for incomplete downloads";
    };

    enableWebInterface = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Enable web interface for Transmission";
    };

    rpcUsername = mkOption {
      type = types.str;
      default = "";
      description = mdDoc "Username for RPC authentication (empty = no auth)";
    };

    rpcPassword = mkOption {
      type = types.str;
      default = "";
      description = mdDoc "Password for RPC authentication (empty = no auth)";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    services.transmission = {
      enable = true;
      web.enable = cfg.enableWebInterface;
      settings = {
        download-dir = cfg.downloadDir;
        incomplete-dir = cfg.incompleteDir;
        incomplete-dir-enabled = true;
        
        # RPC settings for Sonarr/Radarr integration
        rpc-bind-address = "0.0.0.0";
        rpc-port = cfg.port;
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
        
        # Authentication
        rpc-authentication-required = cfg.rpcUsername != "";
        rpc-username = cfg.rpcUsername;
        rpc-password = cfg.rpcPassword;
        
        # Performance settings
        cache-size-mb = 16;
        prefetch-enabled = true;
        
        # Privacy/security
        dht-enabled = false;
        pex-enabled = false;
        lpd-enabled = false;
      };
    };

    # Create directories and set permissions
    system.activationScripts.transmission-setup = ''
      mkdir -p ${cfg.downloadDir}
      mkdir -p ${cfg.incompleteDir}
      
      # Create transmission group if it doesn't exist
      if ! getent group transmission > /dev/null 2>&1; then
        ${pkgs.shadow}/bin/groupadd transmission
      fi
      
      # Set permissions - allow read access for other services
      chown -R transmission:transmission ${cfg.downloadDir} ${cfg.incompleteDir}
      chmod -R 755 ${cfg.downloadDir} ${cfg.incompleteDir}
    '';

    # Nginx proxy for web interface
    services.nginx.virtualHosts = mkIf (config.my.homelab.nginx.enable && cfg.enableWebInterface) {
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
  };
}
