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

        # API subdomain
        "api.dorkoe.nl" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://localhost:3001";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };

        # Blog subdomain
        "blog.dorkoe.nl" = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            root = "/var/www/blog";
            tryFiles = "$uri $uri/ =404";
          };
        };

        # Nextcloud subdomain
        "cloud.dorkoe.nl" = {
          enableACME = true;
          forceSSL = true;

          # Special Nextcloud nginx configuration
          extraConfig = ''
            # Add headers to serve security related headers
            add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;
            add_header Referrer-Policy "no-referrer" always;
            add_header X-Content-Type-Options "nosniff" always;
            add_header X-Download-Options "noopen" always;
            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header X-Permitted-Cross-Domain-Policies "none" always;
            add_header X-Robots-Tag "none" always;
            add_header X-XSS-Protection "1; mode=block" always;

            # Remove X-Powered-By, which is an information leak
            fastcgi_hide_header X-Powered-By;

            # Path to the root of your installation
            root ${config.services.nextcloud.package};

            # set max upload size
            client_max_body_size 512M;
            fastcgi_buffers 64 4K;

            # Enable gzip but do not remove ETag headers
            gzip on;
            gzip_vary on;
            gzip_comp_level 4;
            gzip_min_length 256;
            gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
            gzip_types application/atom+xml application/javascript application/json application/ld+json application/manifest+json application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject application/x-font-ttf application/x-web-app-manifest+json application/xhtml+xml application/xml font/opentype image/bmp image/svg+xml image/x-icon text/cache-manifest text/css text/plain text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

            # Pagespeed is not supported by Nextcloud, so if your server is built
            # with the `ngx_pagespeed` module, uncomment this line to disable it.
            #pagespeed off;

            # HTTP response headers borrowed from Nextcloud `.htaccess`
            add_header Referrer-Policy                      "no-referrer"   always;
            add_header X-Content-Type-Options               "nosniff"       always;
            add_header X-Download-Options                   "noopen"        always;
            add_header X-Frame-Options                      "SAMEORIGIN"    always;
            add_header X-Permitted-Cross-Domain-Policies    "none"          always;
            add_header X-Robots-Tag                         "none"          always;
            add_header X-XSS-Protection                     "1; mode=block" always;

            # Remove X-Powered-By, which is an information leak
            fastcgi_hide_header X-Powered-By;
          '';

          locations = {
            "= /robots.txt" = {
              priority = 100;
              extraConfig = ''
                allow all;
                log_not_found off;
                access_log off;
              '';
            };

            "= /.well-known/carddav" = {
              priority = 210;
              extraConfig = "return 301 $scheme://$host/remote.php/dav;";
            };
            "= /.well-known/caldav" = {
              priority = 210;
              extraConfig = "return 301 $scheme://$host/remote.php/dav;";
            };

            "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)" = {
              priority = 450;
              extraConfig = "return 404;";
            };
            "~ ^/(?:\.|autotest|occ|issue|indie|db_|console)" = {
              priority = 450;
              extraConfig = "return 404;";
            };

            "~ \.php(?:$|/)" = {
              priority = 500;
              extraConfig = ''
                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                set $path_info $fastcgi_path_info;

                try_files $fastcgi_script_name =404;

                include ${pkgs.nginx}/conf/fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $path_info;
                fastcgi_param modHeadersAvailable true;

                fastcgi_param front_controller_active true;
                fastcgi_pass unix:${config.services.phpfpm.pools.nextcloud.socket};

                fastcgi_intercept_errors on;
                fastcgi_request_buffering off;
              '';
            };

            "~ \.(?:css|js|svg|gif)$" = {
              priority = 200;
              extraConfig = ''
                try_files $uri /index.php$request_uri;
                expires 6M;
                access_log off;
              '';
            };

            "~ \.woff2?$" = {
              priority = 200;
              extraConfig = ''
                try_files $uri /index.php$request_uri;
                expires 7d;
                access_log off;
              '';
            };

            "/" = {
              priority = 900;
              extraConfig = ''
                try_files $uri $uri/ /index.php$request_uri;
              '';
            };
          };
        };
      };
    };

    # Enable and configure Nextcloud
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;  # Use latest stable version

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
        adminuser = "admin";
        adminpassFile = "/var/lib/nextcloud-admin-pass";
      };

      # Enable additional apps
      extraApps = with config.services.nextcloud.package.packages; [
        contacts
        calendar
        tasks
        notes
        mail
        news
        phonetrack
      ];

      # Extra configuration
      settings = {
        trusted_domains = [ "cloud.dorkoe.nl" ];
        trusted_proxies = [ "127.0.0.1" ];
        "overwrite.cli.url" = "https://cloud.dorkoe.nl";

        # Performance tuning
        "memcache.distributed" = "\\OC\\Memcache\\Redis";
        "memcache.locking" = "\\OC\\Memcache\\Redis";
        "memcache.local" = "\\OC\\Memcache\\APCu";

        # Security
        "default_phone_region" = "US";  # Change to your region

        # File handling
        "max_chunk_size" = 10485760;  # 10MB chunks for large file uploads
      };
    };

    # Enable Redis for Nextcloud caching
    services.redis.servers.nextcloud = {
      enable = true;
      port = 6379;
      bind = "127.0.0.1";
    };

    # Enable PostgreSQL (automatically configured by Nextcloud)
    services.postgresql.enable = true;

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
        mkdir -p /var/www/blog
        chown -R nginx:nginx /var/www
      '';

      nextcloud-admin-pass = ''
        if [ ! -f /var/lib/nextcloud-admin-pass ]; then
          echo "ChangeMePlease123!" > /var/lib/nextcloud-admin-pass
          chmod 600 /var/lib/nextcloud-admin-pass
          chown nextcloud:nextcloud /var/lib/nextcloud-admin-pass
        fi
      '';
    };

    # Optional: Create a simple index page
    environment.etc."var/www/main/index.html".text = ''
      <!DOCTYPE html>
      <html>
      <head><title>My Homelab</title></head>
      <body>
        <h1>Welcome to my homelab!</h1>
        <p>SSL is working with Let's Encrypt!</p>
        <ul>
          <li><a href="https://cloud.dorkoe.nl">Nextcloud</a></li>
          <li><a href="https://blog.dorkoe.nl">Blog</a></li>
          <li><a href="https://api.dorkoe.nl">API</a></li>
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
