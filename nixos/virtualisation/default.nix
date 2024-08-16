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
    users.extraUsers.${config.my.user}.extraGroups = [ "libvirtd" ];

    boot.extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
  };
}
