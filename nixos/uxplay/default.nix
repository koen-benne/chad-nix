{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.uxplay;

in
{
  options.my.uxplay = {
    enable = mkEnableOption (mdDoc "uxplay");
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [ 7000 7001 7100 ];
    networking.firewall.allowedUDPPorts = [ 5353 6000 6001 7011 ];

    hm.my.uxplay.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
        domain = true;
      };
    };
  };
}

