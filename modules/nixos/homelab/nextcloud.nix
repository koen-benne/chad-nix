{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.nextcloud;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.nextcloud = {
    enable = mkEnableOption (mdDoc "Nextcloud cloud storage");

    subdomain = mkOption {
      type = types.str;
      default = "cloud";
      description = mdDoc "Subdomain for Nextcloud";
    };

    adminPassword = mkOption {
      type = types.str;
      default = "PWD";
      description = mdDoc "Admin password for Nextcloud";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/export/1tb/NextCloud/data";
      description = mdDoc "External data directory for Nextcloud";
    };

    extraApps = mkOption {
      type = types.listOf types.str;
      default = ["news" "contacts" "calendar" "tasks" "notes" "mail" "phonetrack"];
      description = mdDoc "List of extra Nextcloud apps to enable";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Create admin password file
    environment.etc."nextcloud-admin-pass".text = cfg.adminPassword;

    # Enable and configure Nextcloud
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      configureRedis = true;

      # Basic configuration
      hostName = "${cfg.subdomain}.${homelabCfg.domain}";
      home = "/var/lib/nextcloud";

      # Database configuration (using PostgreSQL - recommended)
      database.createLocally = true;

      # PHP configuration
      phpOptions = {
        "opcache.interned_strings_buffer" = "8";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "128";
        "opcache.save_comments" = "1";
        "opcache.validate_timestamps" = "1";
        "opcache.revalidate_freq" = "1";
      };

      # Configure admin credentials
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        adminuser = "admin";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };

      # Enable additional apps
      extraApps = let
        availableApps = config.services.nextcloud.package.packages.apps;
        enabledApps = builtins.listToAttrs (
          map (appName: {
            name = appName;
            value = availableApps.${appName};
          }) (builtins.filter (
              appName:
                builtins.hasAttr appName availableApps
            )
            cfg.extraApps)
        );
      in
        enabledApps;

      extraAppsEnable = true;

      # Extra configuration
      settings = {
        trusted_domains = ["${cfg.subdomain}.${homelabCfg.domain}"];
        trusted_proxies = ["127.0.0.1"];
        "overwrite.cli.url" = "https://${cfg.subdomain}.${homelabCfg.domain}";

        # File handling
        "max_chunk_size" = 10485760; # 10MB chunks for large file uploads
      };
    };

    # Mount external data directory
    fileSystems."/var/lib/nextcloud/data" = {
      device = cfg.dataDir;
      options = ["bind"];
    };

    # Add Nextcloud virtual host to nginx if nginx is enabled
    services.nginx.virtualHosts = mkIf config.my.homelab.nginx.enable {
      "${cfg.subdomain}.${homelabCfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        # Nextcloud handles its own nginx configuration
      };
    };
  };
}
