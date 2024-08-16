{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.virtualisation;
in {
  options.my.virtualisation = {
    enable = mkEnableOption (mdDoc "virtualisation");
  };

  config = mkIf cfg.enable {
    hm.my.virtualisation.enable = true;

    virtualisation.libvirtd.enable = true;
    users.extraUsers.${config.my.user}.extraGroups = [ "kvm" "libvirtd" "input" ];

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';
  };
}
