#tThe whole "my" section needs to go, it can be defined in different places instead
{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./my/default.nix
  ] ++ lib.my.getHmModules [ ./. ];

  # let standalone home-manager and home-manager in nixos/nix-darwin use the same derivation
  home.packages = [
    (pkgs.callPackage (inputs.home-manager + /home-manager) { path = inputs.home-manager; })
  ];
  home.stateVersion = "23.11";
  systemd.user.startServices = "sd-switch";
}
