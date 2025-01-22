{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.darwinModules.home-manager
      ../common
    ]
    ++ lib.my.getModules [./.];

  hm.imports = [
    ./home.nix
  ];
}
