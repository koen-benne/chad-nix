{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.mdns;
in {
  options.my.mdns = {
    enable = mkEnableOption (mdDoc "mdns");
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns = true;
      ipv4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
  };
}

