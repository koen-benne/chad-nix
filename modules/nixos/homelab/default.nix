{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.homelab;
in {
  options.my.homelab = {
    enable = mkEnableOption (mdDoc "Homelab");
  };

  config = mkIf cfg.enable {
    # Enable nginx
    services.nginx = {
      enable = true;

      # Recommended settings for Let's Encrypt
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # Define your virtual hosts with SSL
      virtualHosts = {
        # Main domain
        "dorkoe.nl" = {
          enableACME = true;  # This enables Let's Encrypt
          forceSSL = true;    # Redirects HTTP to HTTPS

          locations."/" = {
            root = "/var/www/main";
            index = "index.html";
          };
        };

        # www subdomain
        "www.dorkoe.nl" = {
          enableACME = true;
          forceSSL = true;

          # Redirect www to non-www (optional)
          globalRedirect = "dorkoe.nl";
        };

        # Nextcloud subdomain
        "cloud.dorkoe.nl" = {
          enableACME = true;
          forceSSL = true;
          # Other config is handled by nextcloud config itself
        };
      };
    };


    environment.etc."nextcloud-admin-pass".text = "PWD";
    # Enable and configure Nextcloud
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      configureRedis = true;

      # Basic configuration
      hostName = "cloud.dorkoe.nl";
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
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks notes mail phonetrack;
      };

      extraAppsEnable = true;

      # Extra configuration
      settings = {
        trusted_domains = [ "cloud.dorkoe.nl" ];
        trusted_proxies = [ "127.0.0.1" ];
        "overwrite.cli.url" = "https://cloud.dorkoe.nl";

        # File handling
        "max_chunk_size" = 10485760;  # 10MB chunks for large file uploads
      };
    };

    fileSystems."/var/lib/nextcloud/data" = {
      device = "/export/1tb/NextCloud/data";
      options = [ "bind" ];
    };

    # Configure ACME (Let's Encrypt)
    security.acme = {
      acceptTerms = true;
      # Replace with your actual email
      defaults.email = "koen.benne@gmail.com";
    };

    # Open firewall ports
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    # Create web directories and admin password
    system.activationScripts = {
      webdirs = ''
        mkdir -p /var/www/main
        chown -R nginx:nginx /var/www
      '';
    };

    # Optional: Create a simple index page
    environment.etc."var/www/main/index.html".text = ''
      <!DOCTYPE html>
      <html>
      <head><title>My Homelab</title></head>
      <body>
        <h1>Welcome to my homelab!</h1>
        <ul>
          <li><a href="https://cloud.dorkoe.nl">Nextcloud</a></li>
        </ul>
      </body>
      </html>
    '';

    # Ensure required users and groups exist
    users.users.nextcloud = {
      isSystemUser = true;
      group = "nextcloud";
    };
    users.groups.nextcloud = {};
  };
}
