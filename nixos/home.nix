{ inputs, lib, ... }:

{
  imports = [
    inputs.arkenfox-nix.hmModules.arkenfox
    inputs.spicetify-nix.homeManagerModule
  ] ++ lib.my.getHmModules [ ./. ];
}
