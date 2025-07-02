# Entry point when using nixos-rebuild switch
{
  inputs,
  withSystem,
  ...
}: let
  mkNixos = {
    system ? "x86_64-linux",
    modules ? [],
  }:
    withSystem system ({
      lib,
      pkgs,
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        specialArgs = {inherit inputs lib;};
        modules =
          [
            ../modules/nixos
            inputs.nixpkgs.nixosModules.readOnlyPkgs
          ]
          ++ modules;
      });
in {
  flake.nixosConfigurations = {
    nixos = mkNixos {
      modules = [../hosts/nixos];
    };
    nixos-work = mkNixos {
      system = "aarch64-linux";
      modules = [../hosts/nixos-work];
    };
    nixos-server = mkNixos {
      modules = [../hosts/nixos-server];
    };
  };
}
