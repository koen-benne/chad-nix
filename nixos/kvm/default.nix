{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption listOf types;
  cfg = config.my.kvm;
  files = ./files;
in {
  options.my.kvm = with types; {
    enable = mkEnableOption (mdDoc "kvm");
    gpuPciIds = mkOption {
      type = listOf str;
      default = [ ];
      description = "The hardware IDs to pass through to a virtual machine.";
    };
    platform = mkOption {
      type = enum [
        "amd"
        "intel"
      ];
      default = "amd";
      description = "The CPU platform the machine is using.";
    };
  };

  config = mkIf cfg.enable {
    hm.my.kvm.enable = true;

    boot = {
      kernelModules = [
        "kvm-${cfg.platform}"
        "vfio-virqfd"
        "vfio-pci"
        "vfio_iommu_type1"
        "vfio"
      ];
      kernelParams = [
      "${cfg.platform}_iommu=on"
      "${cfg.platform}_iommu=pt"
      "kvm.ignore_msrs=1"
      # "video=efifb:off"
      ];
    };

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu.ovmf.enable = true;
      qemu.runAsRoot = true;
      qemu.swtpm.enable = true;
    };

    users.users.${config.my.user}.extraGroups = ["qemu-libvirtd" "disk" "kvm" "libvirtd" "input"];

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
    '';

    # Link hooks to the correct directory
    system.activationScripts.libvirt-hooks.text = ''
      ln -Tfs /etc/libvirt/hooks /var/lib/libvirt/hooks
    '';

    environment.etc = {
      "libvirt/hooks/qemu" = {
        source = ./files/qemu;
        mode = "0755";
      };

      "libvirt/hooks/kvm.conf" = {
        source = ./files/kvm.conf;
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/macOS/prepare/begin/start.sh" = {
        source = ./files/start.sh;
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/macOS/release/end/stop.sh" = {
        source = ./files/stop.sh;
        mode = "0755";
      };

      "libvirt/vgabios/6700XT.rom".source = ./files/6700XT.rom;
    };
  };
}
