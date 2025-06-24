{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.virtualisation;
  files = ./files;
in {
  options.my.virtualisation = {
    enable = mkEnableOption (mdDoc "virtualisation");
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = [config.my.user];
    users.users.${config.my.user}.extragroups = [ "libvirtd" ];

    virtualisation.libvirtd.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
