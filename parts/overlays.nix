{self, ...}: {
  flake.overlays.default = import ../overlays/default.nix;

  perSystem = {
    lib,
    system,
    ...
  }: let
    # Define config once
    sharedConfig = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
      permittedInsecurePackages = [
        "dotnet-runtime-7.0.20"
      ];
    };

    pkgs = import self.inputs.nixpkgs {
      inherit system;
      config = sharedConfig;
      overlays = [
        # Add unstable with inherited config
        (final: prev: {
          unstable = import self.inputs.unstable {
            inherit system;
            config = sharedConfig;  # Same config as main nixpkgs
          };
        })
        self.inputs.apple-silicon.overlays.default
        self.overlays.default
        self.inputs.dev-flakes.overlays.default
        self.inputs.nix-minecraft.overlay
        self.inputs.chaotic.overlays.cache-friendly
        self.inputs.niri.overlays.niri
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
