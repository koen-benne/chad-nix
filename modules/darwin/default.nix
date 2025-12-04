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

  # Let Determinate Nix handle Nix configuration rather than nix-darwin
  nix.enable = false;
}
