{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common
  ] ++ lib.my.getModules [ ./. ];

  hm.imports = [
    inputs.spicetify-nix.homeManagerModule
  ] ++ lib.my.getHmModules [ ./. ];
}
