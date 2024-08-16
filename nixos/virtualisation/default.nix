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
    hm.my.virtualisation.enable = true;


    boot.kernelParams = ["amd_iommu=on"];
    boot.kernelModules = ["kvm-amd" "vfio-pci"];
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemuOvmf = true;
      qemuRunAsRoot = true;
    };

    # Add binaries to path so that hooks can use it
    systemd.services.libvirtd = {
      path = let
        env = pkgs.buildEnv {
          name = "qemu-hook-env";
          paths = with pkgs; [
            bash
            libvirt
            kmod
            systemd
            ripgrep
            sd
          ];
        };
      in
      [ env ];

      preStart =
      ''
        mkdir -p /var/lib/libvirt/hooks
        mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin
        mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS/release/end
        mkdir -p /var/lib/libvirt/vgabios

        ln -sf ${files}/qemu /var/lib/libvirt/hooks/qemu
        ln -sf ${files}/kvm.conf /var/lib/libvirt/hooks/kvm.conf
        ln -sf ${files}/start.sh /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin/start.sh
        ln -sf ${files}/stop.sh /var/lib/libvirt/hooks/qemu.d/macOS/release/end/stop.sh
        ln -sf ${files}/6700xt.rom /var/lib/libvirt/vgabios/6700XT.rom

        chmod +x /var/lib/libvirt/hooks/qemu
        chmod +x /var/lib/libvirt/hooks/kvm.conf
        chmod +x /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin/start.sh
        chmod +x /var/lib/libvirt/hooks/qemu.d/macOS/release/end/stop.sh
      '';
    };

    users.extraUsers.${config.my.user}.extraGroups = [ "kvm" "libvirtd" "input" ];

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';
  };
}
