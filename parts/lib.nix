{
  perSystem = {lib, ...}: {
    _module.args.lib = lib.extend (final: prev: {
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
        wrapGL = config: cmd:
          if config.my.isStandalone or false
          then "nixGLIntel ${cmd}"
          else cmd;
      };
    });
  };
}
