# Entry point when using home-manager switch
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
    # Linux configurations
    "koenbenne@nixos" = mkHome {
      system = "x86_64-linux";
      username = "koenbenne";
      modules = [../hosts/nixos/home.nix];
    };
    "koenbenne@nixos-work" = mkHome {
      system = "aarch64-linux";
      username = "koenbenne";
      modules = [../hosts/nixos-work/home.nix];
    };
    "koenbenne@debian-vm" = mkHome {
      system = "x86_64-linux";
      username = "koenbenne";
      modules = [../hosts/debian-vm/home.nix];
    };

    # macOS configurations
    "koenbenne@work-mac" = mkHome {
      system = "aarch64-darwin";
      username = "koenbenne";
      modules = [../hosts/work-mac/home.nix];
    };
    "koenbenne@music-mac" = mkHome {
      system = "aarch64-darwin";
      username = "koenbenne";
      modules = [../hosts/music-mac/home.nix];
    };
  };
}
