# Entry point when using home-manager switch
# This is only for systems that can't use NixOS/nix-darwin system management
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
            my = let
              lib = final;
              getPaths = file: root:
                builtins.filter builtins.pathExists
                (map (dir: root + "/${dir}/${file}")
                  (lib.attrNames
                    (lib.filterAttrs (name: type: type == "directory")
                      (builtins.readDir root))));
            in {
              inherit getPaths;
              getModules = builtins.concatMap (getPaths "default.nix");
              getHmModules = builtins.concatMap (getPaths "home.nix");
              getCompatModules = builtins.concatMap (getPaths "compat.nix");
            };
          });
        };
        modules =
          [
            {
              home.username = username;
              home.homeDirectory =
                if pkgs.stdenv.isDarwin
                then "/Users/${username}"
                else "/home/${username}";
            }
            ../modules/home-manager-compat
          ]
          ++ modules;
      });
in {
  flake.homeConfigurations = {
    # Machine-specific home-manager configurations for non-NixOS systems
    koenbenne = mkHome {
      system = "x86_64-linux";
      username = "koenbenne";
      modules = [../hosts/debian-vm/home.nix];
    };
  };
}
