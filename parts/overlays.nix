{self, ...}: {
  flake.overlays.default = import ../overlays/default.nix;

  perSystem = {
    lib,
    system,
    ...
  }: let
    pkgs = import self.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        # Add unstable
        (final: prev: {
          unstable = import self.inputs.unstable (final // {config.allowUnfree = true;});
        })
        # wait for https://github.com/LnL7/nix-darwin/pull/942 and nh 4 in nixpkgs to remove this overlay
        self.inputs.nh.overlays.default
        self.overlays.default
        self.inputs.nvim-nix.overlays.default
        self.inputs.dev-flakes.overlays.default
        self.inputs.nix-minecraft.overlay
      ];
    };
  in {
    _module.args.pkgs = pkgs;

    packages =
      lib.filterAttrs
      (_: value: value ? type && value.type == "derivation")
      (builtins.mapAttrs
        (name: _: pkgs.${name})
        (self.overlays.default {} {}));
  };
}
