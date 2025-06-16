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
        self.overlays.default
        self.inputs.dev-flakes.overlays.default
        self.inputs.nix-minecraft.overlay
        # This has to be done manually due to _module.args.pkgs which locks pkgs.
        # Modules cannot override by themselves due to this, but it does make one global instance of pkgs.
        self.inputs.chaotic.overlays.cache-friendly
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
