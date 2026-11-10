{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.collabora;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.collabora = {
    enable = mkEnableOption "Collabora Online (Nextcloud Office)";

    subdomain = mkOption {
      type = types.str;
      default = "office";
      description = "Subdomain for Collabora Online";
    };

    port = mkOption {
      type = types.port;
      default = 9980;
      description = "Local port for the Collabora Online (coolwsd) daemon";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    services.collabora-online = {
      enable = true;
      port = cfg.port;

      settings = {
        # Only reachable via the local nginx reverse proxy.
        net.listen = "loopback";
        net.proto = "IPv4";  # <- new: without this, coolwsd binds [::1] only on this host


        # TLS is terminated upstream (nginx -> cloudflared -> Cloudflare edge),
        # so coolwsd talks plain HTTP/WS locally but reports itself as https.
        ssl.enable = false;
        ssl.termination = true;
      };
    };

    # Reverse proxy the Collabora Online daemon on its own subdomain, since it
    # is a standalone service (not a path under the Nextcloud vhost).
    services.nginx.virtualHosts = mkIf homelabCfg.nginx.enable {
      "${cfg.subdomain}.${homelabCfg.domain}" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
        };
      };
    };

    # Point Nextcloud's richdocuments app at this Collabora instance.
    systemd.services.nextcloud-richdocuments-setup = mkIf homelabCfg.nextcloud.enable {
      description = "Configure Nextcloud richdocuments to use Collabora Online";
      after = ["nextcloud-setup.service" "coolwsd.service"];
      wants = ["nextcloud-setup.service" "coolwsd.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        # Run as the Nextcloud user to avoid sudo TTY requirement in occ wrapper.
        User = "nextcloud";
        KillMode = "none";
        # Retry on failure with 30s delay (e.g., if Collabora not yet ready on first run).
        Restart = "on-failure";
        RestartSec = "30s";
      };

      script = ''
        ${lib.getExe config.services.nextcloud.occ} richdocuments:activate-config --wopi-url="https://${cfg.subdomain}.${homelabCfg.domain}"
      '';
    };
  };
}
