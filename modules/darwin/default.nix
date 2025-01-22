{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.home-manager.darwinModules.home-manager
      inputs.nix-homebrew.darwinModules.nix-homebrew
      ../common
    ]
    ++ lib.my.getModules [
      # ../modules/darwin
      ./.
    ];

  hm.imports = [
    ./home.nix
  ];
}
