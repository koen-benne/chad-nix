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
    boot.kernelParams = ["amd_iommu=on" "iommu=pt"];
    boot.kernelModules = ["kvm-amd" "vfio-pci"];

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu.ovmf.enable = true;
      qemu.runAsRoot = true;
      qemu.swtpm.enable = true;
    };

    # Fix networking
    networking.firewall = {
      checkReversePath = false;
      trustedInterfaces = [ "virbr0" ];
      extraCommands = ''
        # Ensure proper NAT for libvirt
        iptables -t nat -A LIBVIRT_PRT -s 192.168.122.0/24 -o enp9s0 -j MASQUERADE
      '';
    };

    # Ensure default network starts
    systemd.services.libvirtd.postStart = ''
      sleep 1
      ${pkgs.libvirt}/bin/virsh net-autostart default || true
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';

    users.extraUsers.${config.my.user}.extraGroups = ["kvm" "libvirtd" "input"];

    programs.virt-manager.enable = true;
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      bridge-utils
      iptables
    ];

    boot.extraModprobeConfig = ''
      options kvm_amd nested=1
      options kvm ignore_msrs=1 report_ignored_msrs=0
    '';

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
