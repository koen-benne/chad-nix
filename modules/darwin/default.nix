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
      {
        nix-homebrew = {
          enable = true;
          user = config.my.user;
          enableRosetta = true;
          taps = {
            "homebrew/homebrew-core" = inputs.homebrew-core;
            "homebrew/homebrew-cask" = inputs.homebrew-cask;
            "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
          };
          mutableTaps = false;
          autoMigrate = true;
        };
      }
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
