{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.chaotic.nixosModules.nyx-cache
      inputs.chaotic.nixosModules.nyx-overlay
      inputs.chaotic.nixosModules.nyx-registry
      inputs.home-manager.nixosModules.home-manager
      ../common
    ]
    ++ lib.my.getModules [./.];

  hm.imports = [
    ./home.nix
  ];
}
