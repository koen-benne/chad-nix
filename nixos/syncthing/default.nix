{
  config,
  lib,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.syncthing;
in {
  options.my.syncthing = {
    enable = mkEnableOption (mdDoc "syncthing");
  };

  config = mkIf cfg.enable {
    hm.my.syncthing.enable = true;

    networking.firewall.allowedTCPPorts = [22067 22070];
  };
}
