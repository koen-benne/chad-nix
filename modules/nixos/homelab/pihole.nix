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
  options.my.homelab.pihole = {
    enable = mkEnableOption (mdDoc "Pi-hole");
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Main Pi-hole FTL service
    services.pihole-ftl = {
      enable = true;
      openFirewallDNS = true;  # Automatically opens port 53

      lists = [
        {
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
          description = "Steven Black's unified adlist";
        }
      ];

      settings = {
        dns = {
          upstreams = [ "1.1.1.1" "8.8.8.8" ];
          # ... other DNS settings
        };
      };
    };
  };
}
