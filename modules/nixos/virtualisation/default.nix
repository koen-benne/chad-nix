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
    users.users.${config.my.user}.extraGroups = [ "kvm" "libvirtd" "input" ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    virtualisation.spiceUSBRedirection.enable = true;

    networking.firewall = {
      trustedInterfaces = [ "virbr0" ];
    };
  };
}
