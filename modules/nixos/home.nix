{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.arkenfox-nix.hmModules.arkenfox
      inputs.spicetify-nix.homeManagerModules.default
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];
}
