# All NixOS systems will have this in their configuration
{ config, lib, pkgs, ... }:
{
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };
  boot.loader = {
    efi = {
      canTouchEfiVariables = lib.mkDefault true;
      efiSysMountPoint = lib.mkIf
        (builtins.hasAttr "/boot/efi" config.fileSystems &&
          config.fileSystems."/boot/efi".fsType == "vfat")
        "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
    };
  };
  # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
  # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";

    # Not officially in the specification
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
  # environment.systemPackages = lib.optionals (config.boot.loader.grub.enable == true) [ pkgs.grub-reboot-menu ];
  # explicitly enable nixos docs, system like wsl does not enable this
  documentation.nixos.enable = true;
  networking.enableIPv6 = false;
  networking.nftables.enable = true;
  networking.useNetworkd = lib.mkDefault true;
  # systemd.network.wait-online.anyInterface = config.networking.useDHCP;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # nix.settings.allowed-users = [ config.my.user ];
  programs.ssh.startAgent = true;
  # CVE-2023-38408
  programs.ssh.agentPKCS11Whitelist = "''";
  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults requiretty
    '';
  };
  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  # nix profile diff-closures --profile /nix/var/nix/profiles/system
  system.activationScripts.systemDiff = ''
    # show upgrade diff
    if [ -e /run/current-system ]
    then
      ${pkgs.nix}/bin/nix store --experimental-features nix-command diff-closures /run/current-system "$systemConfig" || true
    fi
  '';
  system.stateVersion = "23.11";
  users.groups.${config.my.user} = {
    gid = config.my.uid;
  };
  users.users.${config.my.user} = {
    # `users` is the primary group of all normal users in NixOS
    extraGroups = [ "users" "wheel" "seat" "power" ];
    group = config.my.user;
    isNormalUser = true;
    shell = pkgs.fish;
    uid = config.my.uid;
    #openssh.authorizedKeys.keys = config.my.keys;
  };
}
