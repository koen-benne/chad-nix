{
  config,
  lib,
  pkgs,
  ...
}: {
  # Nix configuration is handled by Determinate Nix
  # Determinate Nix uses /etc/nix/nix.custom.conf for custom settings, so no conflicts
  nix.settings = {
    auto-optimise-store = true;
    extra-experimental-features = ["flakes" "nix-command"];
    keep-outputs = true;
    log-lines = 25;
    tarball-ttl = 43200;
    trusted-users = ["root" config.my.user];
    eval-cores = 0;
    nix-path = ["nixpkgs=${pkgs.path}"];
  };
  nix.extraOptions = ''
    !include ${config.sops.secrets.github_access_token.path}
  '';
  programs.fish.enable = true;
  time.timeZone = "Europe/Amsterdam";

  environment.variables = {
    NH_FLAKE = "${config.my.home}/.config/chad-nix";
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = ["${XDG_BIN_HOME}"];
  };
  documentation.nixos.enable = true;
  networking.nftables.enable = false;
  networking.useNetworkd = lib.mkDefault true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  services.dbus.packages = [pkgs.gcr];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  programs.ssh.agentPKCS11Whitelist = "''";
  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
    extraConfig = ''
      Defaults requiretty
    '';
  };

  system.activationScripts.systemDiff = ''
    if [ -e /run/current-system ]
    then
      ${pkgs.nix}/bin/nix store --experimental-features nix-command diff-closures /run/current-system "$systemConfig" || true
    fi
  '';
  users.groups.${config.my.user} = {
    gid = config.my.uid;
  };
  users.users.${config.my.user} = {
    extraGroups = ["users" "wheel" "seat" "power"];
    group = config.my.user;
    isNormalUser = true;
    shell = pkgs.fish;
    uid = config.my.uid;
    openssh.authorizedKeys.keys = config.my.keys;
  };
  users.users.root = {
    openssh.authorizedKeys.keys = map (key: ''restrict,from="192.168.68.0/24",command="internal-sftp" ${key}'') config.my.keys;
  };
}
