{ inputs, withSystem, ... }:

let
  mkDarwin = { system ? "x86_64-darwin", modules ? [ ] }:
    withSystem system ({ lib, pkgs, system, ... }: inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs lib pkgs; };
      modules = [
        ../darwin
      ] ++ modules;
    });
in
{
  flake.darwinConfigurations = {
    "MBP-KoenB" = mkDarwin {
      modules = [ ../hosts/MBP-KoenB.nix ];
    };
  };
}
