# Entry point when using darwin-rebuild switch
{
  inputs,
  withSystem,
  ...
}: let
  mkDarwin = {
    system ? "aarch64-darwin",
    modules ? [],
  }:
    withSystem system ({
      lib,
      pkgs,
      system,
      ...
    }:
      inputs.darwin.lib.darwinSystem {
        specialArgs = {inherit inputs lib pkgs;};
        modules =
          [
            ../modules/darwin
            inputs.nixpkgs.nixosModules.readOnlyPkgs
          ]
          ++ modules;
      });
in {
  flake.darwinConfigurations = {
    "RQG5XMDJF4" = mkDarwin {
      modules = [../hosts/work-mac];
    };
    "music-mac" = mkDarwin {
      modules = [../hosts/music-mac];
    };
  };
}
