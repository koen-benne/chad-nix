{
  config,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.syncthing;
in {
  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
