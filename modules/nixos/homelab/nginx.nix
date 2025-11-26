{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.homelab.nginx;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.nginx = {
    enable = mkEnableOption (mdDoc "Nginx web server for homelab");

    mainSite = {
      enable = mkEnableOption (mdDoc "Main website");
      root = lib.mkOption {
        type = lib.types.path;
        default = "/var/www/main";
        description = mdDoc "Root directory for main website";
      };
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
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
        "${homelabCfg.domain}" = mkIf cfg.mainSite.enable {
          enableACME = true; # This enables Let's Encrypt
          forceSSL = true; # Redirects HTTP to HTTPS

          locations."/" = {
            root = cfg.mainSite.root;
            index = "index.html";
          };
        };

        # www subdomain
        "www.${homelabCfg.domain}" = mkIf cfg.mainSite.enable {
          enableACME = true;
          forceSSL = true;

          # Redirect www to non-www
          globalRedirect = homelabCfg.domain;
        };
      };
    };

    # Create web directories only if main site is enabled
    system.activationScripts = mkIf cfg.mainSite.enable {
      webdirs = ''
        mkdir -p ${cfg.mainSite.root}
        chown -R nginx:nginx /var/www
      '';
    };

    # Create a simple index page only if main site is enabled
    environment.etc."var/www/main/index.html" = mkIf cfg.mainSite.enable {
      text = ''
            <!DOCTYPE html>
            <html>
            <head><title>My Homelab</title></head>
            <body>
              <h1>Welcome to my homelab!</h1>
              <ul>
                ${lib.optionalString config.my.homelab.nextcloud.enable
          ''<li><a href="https://cloud.${homelabCfg.domain}">Nextcloud</a></li>''}
        ${lib.optionalString config.my.homelab.jellyfin.enable
          ''<li><a href="https://jellyfin.${homelabCfg.domain}">Jellyfin</a></li>''}
              </ul>
            </body>
            </html>
      '';
    };
  };
}
