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
    enable = mkEnableOption (mdDoc "NextCloud");
  };

  config = mkIf cfg.enable {
    environment.etc."nextcloud-admin-pass".text = "PWD";
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "nextcloud.local";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      config.extraTrustedDomains = ["92.168.68.54"];
    };
  };
}
