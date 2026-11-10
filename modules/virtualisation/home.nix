{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.virtualisation;
in {
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
