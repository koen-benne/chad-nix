{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.pihole;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.pihole = {
    enable = mkEnableOption (mdDoc "Pi-hole");
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Main Pi-hole FTL service
    networking.firewall = {
      allowedTCPPorts = [8080];
    };
    services.resolved.enable = false;

    services.pihole-ftl = {
      enable = true;
      openFirewallDNS = true;  # Automatically opens port 53

      lists = [
        {
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          description = "Steven Black's unified adlist";
        }
        {
          # JW Player CDN domains blocked by Steven Black list but needed for legitimate video players
          url = "file://${pkgs.writeText "pihole-whitelist" ''
            assets-jpcust.jwpsrv.com
            g.jwpsrv.com
            entitlements.jwplayer.com
            assets-secure.applicaster.com
          ''}";
          type = "allow";
          description = "JW Player / Applicaster video platform whitelist";
        }
      ];

      settings = {
        dns = {
          upstreams = [ "1.1.1.1" "8.8.8.8" ];
          # ... other DNS settings
        };
      };
    };
    services.pihole-web = {
      enable = true;
      ports = ["8080s"];
    };
  };
}
