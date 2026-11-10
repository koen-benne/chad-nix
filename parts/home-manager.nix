# Entry point when using home-manager switch
# This is only for systems that can't use NixOS system management
{
  inputs,
  withSystem,
  ...
}: let
  mkHome = {
    system ? "x86_64-linux",
    username ? "koen",
    modules ? [],
  }:
    withSystem system ({
      lib,
      pkgs,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          lib = lib.extend (final: prev: {
            hm = inputs.home-manager.lib.hm;
            my = import ../lib/my.nix final;
          });
        };
        modules =
          [
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ]
          ++ modules;
      });
in {
  flake.homeConfigurations = {
    # Machine-specific home-manager configurations for non-NixOS systems
    koenbenne = mkHome {
      system = "x86_64-linux";
      username = "koenbenne";
      modules = [../hosts/debian-work/home.nix];
    };
  };
}
