{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  homelabCfg = config.my.homelab;
in {
  config = mkIf (homelabCfg.enable) {
    sops.secrets.cloudflared_creds = {
      owner = config.my.user;
      group = "users";
      mode = "0400";
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "897c56b2-b2b3-4085-bc66-b18fde4979d2" = {
          credentialsFile = "${config.sops.secrets.cloudflared_creds.path}";
          ingress = {
            "*.${homelabCfg.domain}" = "http://localhost:80";
            "${homelabCfg.domain}" = "http://localhost:80";
          };
          default = "http_status:404";
        };
      };
    };
  };
}
