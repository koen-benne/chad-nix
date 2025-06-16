{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ../common
    ]
    ++ lib.my.getModules [./.];

  hm.imports = [
    ./home.nix
  ];
}
