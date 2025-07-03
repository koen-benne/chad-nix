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
      ...
    }:
      inputs.darwin.lib.darwinSystem {
        inherit pkgs;
        specialArgs = {inherit inputs lib;};
        modules =
          [
            ../modules/darwin
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
