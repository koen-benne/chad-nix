{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.arkenfox-nix.hmModules.arkenfox
      inputs.spicetify-nix.homeManagerModules.default
    ]
    ++ lib.my.getHmModules [./.];
}
