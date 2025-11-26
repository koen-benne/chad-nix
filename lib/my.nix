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

  # Wrap commands with nixGL for standalone home-manager mode
  wrapGL = config: cmd:
    if config.my.isStandalone or false
    then
      if builtins.isList cmd
      then ["nixGLIntel"] ++ cmd
      else "nixGLIntel ${cmd}"
    else cmd;

  # Wrap a package with nixGL for standalone home-manager mode
  # This wraps the actual executables so both CLI usage and .desktop files work
  # Usage: lib.my.wrapPackage { inherit pkgs config inputs; package = pkgs.somePackage; }
  wrapPackage = {
    pkgs,
    config,
    inputs,
    package,
  }:
    if config.my.isStandalone or false
    then let
      nixgl = inputs.nixgl.packages.${pkgs.system};
    in
      pkgs.runCommand "${package.name}-nixgl-wrapper" {
        nativeBuildInputs = [pkgs.makeWrapper];
      } ''
        mkdir -p $out/bin

        # Wrap all binaries from the original package
        for bin in ${package}/bin/*; do
          [ -f "$bin" ] || continue
          binname=$(basename "$bin")
          makeWrapper ${nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/$binname \
            --add-flags "$bin"
        done

        # Symlink everything else (share, lib, etc.)
        for item in ${package}/*; do
          itemname=$(basename "$item")
          if [ "$itemname" != "bin" ]; then
            ln -s "$item" $out/$itemname
          fi
        done
      ''
    else package;
}
