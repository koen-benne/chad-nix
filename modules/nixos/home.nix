{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];
}
