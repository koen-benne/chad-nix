{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.my.homelab.spotweb;
  homelabCfg = config.my.homelab;

  spotweb = pkgs.spotweb;
  appDir = "${spotweb}/share/spotweb";
  initScript = ./spotweb-init.php;

  databaseName = "spotweb";
  databaseUser = "spotweb";
  port = 8090;

  php = pkgs.php82.withExtensions ({enabled, all}:
    enabled
    ++ [
      all.curl
      all.gd
      all.gettext
      all.mbstring
      all.pdo_pgsql
      all.zip
    ]);
in {
  options.my.homelab.spotweb = {
    enable = mkEnableOption "Spotweb";
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Expected SOPS keys:
    #
    # spotweb-admin-password: a plain password
    #
    # spotweb-nntp: JSON, for example:
    # {
    #   "host": "news.example.com",
    #   "port": 563,
    #   "username": "your-username",
    #   "password": "your-password",
    #   "tls": true,
    #   "verifyCertificateName": true
    # }
    sops.secrets = {
      spotweb-admin-password = {};
      spotweb-nntp = {};
    };

    users.groups.spotweb = {};

    users.users.spotweb = {
      isSystemUser = true;
      group = "spotweb";
      home = "/var/lib/spotweb";
      createHome = true;
    };

    services.postgresql = {
      enable = true;

      ensureDatabases = [
        databaseName
      ];

      ensureUsers = [
        {
          name = databaseUser;
          ensureDBOwnership = true;
        }
      ];
    };

    # The Spotweb derivation patches these configuration paths away from the
    # immutable application directory in /nix/store.
    environment.etc."spotweb/dbsettings.inc.php" = {
      mode = "0444";
      text = ''
        <?php

        $dbsettings['engine'] = 'pdo_pgsql';
        $dbsettings['host'] = '/run/postgresql';
        $dbsettings['dbname'] = '${databaseName}';
        $dbsettings['user'] = '${databaseUser}';
        $dbsettings['pass'] = "";
        $dbsettings['port'] = '5432';
        $dbsettings['schema'] = 'public';
      '';
    };

    environment.etc."spotweb/ownsettings.php" = {
      mode = "0444";
      text = ''
        <?php

        /*
         * Leave spotweburl unset: Spotweb derives it from the incoming HTTP
         * request, which is appropriate when accessing it by IP address:port.
         */
        $settings['cache_path'] = '/var/lib/spotweb/cache';
      '';
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/spotweb/cache 0750 spotweb spotweb -"
    ];

    systemd.services.spotweb-init = {
      description = "Initialise Spotweb database and configuration";

      wantedBy = [
        "multi-user.target"
      ];

      after = [
        "postgresql-setup.service"
        "sops-nix.service"
      ];

      requires = [
        "postgresql-setup.service"
      ];

      before = [
        "phpfpm-spotweb.service"
        "spotweb-retrieve.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        User = "spotweb";
        Group = "spotweb";
        StateDirectory = "spotweb";
        RemainAfterExit = true;

        LoadCredential = [
          "admin-password:${config.sops.secrets.spotweb-admin-password.path}"
          "nntp-config:${config.sops.secrets.spotweb-nntp.path}"
        ];
      };

      environment = {
        SPOTWEB_APP_DIR = appDir;

        SPOTWEB_ADMIN_USERNAME = config.my.user;
        SPOTWEB_ADMIN_FIRST_NAME = config.my.user;
        SPOTWEB_ADMIN_LAST_NAME = config.my.user;
        SPOTWEB_ADMIN_EMAIL = config.my.email;
      };

      script = ''
        marker=/var/lib/spotweb/.initialised

        if [[ -e "$marker" ]]; then
          exit 0
        fi

        ${php}/bin/php ${appDir}/bin/upgrade-db.php
        ${php}/bin/php ${initScript}

        touch "$marker"
      '';
    };

    services.phpfpm.pools.spotweb = {
      user = "spotweb";
      group = "spotweb";
      phpPackage = php;

      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "listen.mode" = "0660";

        "pm" = "dynamic";
        "pm.max_children" = 4;
        "pm.start_servers" = 1;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 2;
        "pm.max_requests" = 500;
      };
    };

    systemd.services.phpfpm-spotweb = {
      after = [
        "spotweb-init.service"
      ];

      requires = [
        "spotweb-init.service"
      ];
    };

    services.nginx.virtualHosts.spotweb = {
      listen = [
        {
          addr = "0.0.0.0";
          inherit port;
        }
      ];

      root = appDir;

      locations."/" = {
        tryFiles = "$uri /index.php?$args";
      };

      # Upstream Apache equivalent:
      # RewriteRule api/?$ index.php?page=newznabapi [QSA,L]
      locations."= /api".extraConfig = ''
        rewrite ^ /index.php?page=newznabapi&$args last;
      '';

      # The stock browser installer is deliberately not used.
      locations."= /install.php".extraConfig = "deny all;";
      locations."= /retrieve.php".extraConfig = "deny all;";
      locations."= /settings.php".extraConfig = "deny all;";
      locations."= /dbsettings.inc.php".extraConfig = "deny all;";
      locations."= /ownsettings.php".extraConfig = "deny all;";

      # nginx does not honour Spotweb's bundled Apache .htaccess files.
      locations."~ ^/(?:bin|lib|locales|utils|vendor)/".extraConfig = "deny all;";
      locations."~ /\\.".extraConfig = "deny all;";

      locations."~ \\.php$".extraConfig = ''
        try_files $fastcgi_script_name =404;

        include ${config.services.nginx.package}/conf/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
        fastcgi_pass unix:${config.services.phpfpm.pools.spotweb.socket};
      '';
    };

    systemd.services.spotweb-retrieve = {
      description = "Retrieve Spotnet posts for Spotweb";

      after = [
        "network-online.target"
        "spotweb-init.service"
      ];

      wants = [
        "network-online.target"
      ];

      requires = [
        "spotweb-init.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        User = "spotweb";
        Group = "spotweb";
        StateDirectory = "spotweb";
        WorkingDirectory = appDir;
      };

      script = ''
        exec ${php}/bin/php ${appDir}/retrieve.php
      '';
    };

    systemd.timers.spotweb-retrieve = {
      description = "Periodically retrieve Spotnet posts for Spotweb";

      wantedBy = [
        "timers.target"
      ];

      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
        RandomizedDelaySec = "5m";
      };
    };

    networking.firewall.allowedTCPPorts = [
      port
    ];
  };
}
