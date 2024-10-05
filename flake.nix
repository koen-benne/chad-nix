{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    arkenfox-nix.url = "github:dwarfmaster/arkenfox-nixos";

    nvim-nix.url = "github:koen-benne/nvim-nix";
    dev-flakes.url = "github:koen-benne/dev-flakes";

    nh_darwin.url = "github:ToyVo/nh_darwin";

    stylix.url = "github:danth/stylix";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;

    # Aerospace will soon be in nixpkgs: https://github.com/NixOS/nixpkgs/pull/344015
    aerospace.url = "github:Dirakon/Aerospace-Flake";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-linux"];
      imports = [
        ./parts/lib.nix
        ./parts/overlays.nix
        ./parts/darwin.nix
        ./parts/nixos.nix
        ./parts/home-manager.nix
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (writeShellApplication {
              name = "format";
              runtimeInputs = with pkgs; [alejandra];
              text = "alejandra ./**/*.nix";
            })
            (writeShellApplication {
              name = "check";
              text = ''
                echo "checking flake"
                nix flake check --all-systems --no-build
              '';
            })
            alejandra
          ];
        };
      };
    };
}
