{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.nextcloud;
in {
  options.my.nextcloud = {
    client.enable = mkEnableOption (mdDoc "NextCloud client");
    server.enable = mkEnableOption (mdDoc "NextCloud server");
  };

  config = mkIf cfg.server.enable {
    environment.etc."nextcloud-admin-pass".text = "PWD";
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "92.168.68.54";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      config.extraTrustedDomains = ["192.168.68.*"];
    };
  };
}
