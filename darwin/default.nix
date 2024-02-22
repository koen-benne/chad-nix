{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../common
  ] ++ lib.my.getModules [
    # ../modules/darwin
    ./.
  ];

  hm.imports = [
    ./home.nix
  ];
}
