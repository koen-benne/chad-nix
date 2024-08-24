{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.dnsmasq;
in {
  options.my.dnsmasq = {
    enable = mkEnableOption (mdDoc "dnsmasq");
  };

  config = mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        address = "/.localhost/127.0.0.1";
        server = ["127.0.0.1" "8.8.8.8"];
      };
    };

    services.resolved.enable = false;
  };
}
