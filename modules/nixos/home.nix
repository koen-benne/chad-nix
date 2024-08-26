{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.arkenfox-nix.hmModules.arkenfox
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];
}
