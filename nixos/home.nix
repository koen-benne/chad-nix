{ inputs, lib, ... }:

{
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ] ++ lib.my.getHmModules [ ./. ];
}
