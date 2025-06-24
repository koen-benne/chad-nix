{
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf sys.my.virtualisation.enable {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
