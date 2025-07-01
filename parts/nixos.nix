# Entry point when using nixos-rebuild switch
{
  self,
  inputs,
  withSystem,
  ...
}: let
  mkNixos = {
    system ? "x86_64-linux",
    nixpkgs ? self.inputs.nixpkgs,
    config ? {},
    overlays ? [],
    modules ? [],
  }:
    withSystem system ({
      lib,
      pkgs,
      system,
      ...
    }: let
      customPkgs = import nixpkgs (
        lib.recursiveUpdate
        {
          inherit system;
          overlays = [self.overlays.default] ++ overlays;
          config.allowUnfree = true;
        }
        {
          inherit config;
        }
      );
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit lib;
          inputs = self.inputs;
          pkgs =
            # If self.inputs.nixpkgs is not used or config or overlays is not set, use the customPkgs defined above
            if (nixpkgs != self.inputs.nixpkgs || config != {} || overlays != [])
            then customPkgs
            else pkgs;
        };
        modules =
          [
            ../modules/nixos
          ]
          ++ modules;
      });
in {
  flake.nixosConfigurations = {
    nixos-work = mkNixos {
      system = "aarch64-linux";
      modules = [
        ../hosts/nixos-work
	inputs.apple-silicon.nixosModules.default
      ];
    };
    nixos-server = mkNixos {
      # config.permittedInsecurePackages = [
      # ];
      modules = [../hosts/nixos-server];
    };
  };
}
