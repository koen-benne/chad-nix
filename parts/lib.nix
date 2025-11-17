{
  perSystem = {lib, ...}: {
    _module.args.lib = lib.extend (final: prev: {
      my = import ../lib/my.nix final;
    });
  };
}
