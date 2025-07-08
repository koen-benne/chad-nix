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
  imports = [
    ./nginx.nix
    ./nextcloud.nix
    ./jellyfin.nix
  ];

  options.my.homelab = {
    enable = mkEnableOption (mdDoc "Homelab services");

    domain = lib.mkOption {
      type = lib.types.str;
      default = config.my.domain;
      description = mdDoc "Main domain for homelab services";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = config.my.email;
      description = mdDoc "Email for ACME/Let's Encrypt certificates";
    };
  };

  config = mkIf cfg.enable {
    # Configure ACME (Let's Encrypt) - shared by all services
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.email;
    };

    # Open firewall ports for web services
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    # Ensure required users and groups exist
    users.users.nextcloud = {
      isSystemUser = true;
      group = "nextcloud";
    };
    users.groups.nextcloud = {};
  };
}
