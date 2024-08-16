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
    virtualisation.libvirtd.enable = true;
    users.extraUsers.${config.my.user}.extraGroups = [ "kvm" "libvirtd" "input" ];

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';
  };
}
