# Shared lib.my functions for both full flake and home-manager-only modes
lib: let
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
}
