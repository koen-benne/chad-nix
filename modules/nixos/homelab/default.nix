{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.homelab;
in {
  imports = [
    ./nginx.nix
    ./nextcloud.nix
    ./collabora.nix
    ./jellyfin.nix
    ./pihole.nix
    ./cloudflared.nix
  ];

  options.my.homelab = {
    enable = mkEnableOption "Homelab services";

    domain = lib.mkOption {
      type = lib.types.str;
      default = config.my.domain;
      description = "Main domain for homelab services";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = config.my.email;
      description = "Email for ACME/Let's Encrypt certificates";
    };
  };

  config = mkIf cfg.enable {
    # Configure fail2ban for attackers
    services.fail2ban = {
      enable = true;
      maxretry = 5; # Ban after 5 failed attempts
      bantime = "1h"; # Ban for 1 hour (default is 10m)
      ignoreIP = [
        "192.168.68.0/24" # Whitelist your local network
        "127.0.0.1/8" # Whitelist localhost
      ];
    };
  };
}
