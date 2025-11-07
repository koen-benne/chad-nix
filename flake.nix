{
  inputs = {
    # Package sources
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    system-manager.url = "github:numtide/system-manager";
    system-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon/main";

    # spicetify-nix.url = "github:Gerg-L/spicetify-nix/for-25.05";
    # no clue why, but master works just fine
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "unstable";

    # arkenfox-nix.url = "github:dwarfmaster/arkenfox-nixos";

    neovim.url = "github:koen-benne/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";

    dev-flakes.url = "github:koen-benne/dev-flakes";
    dev-flakes.inputs.nixpkgs.follows = "unstable";

    stylix.url = "github:danth/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;

    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Zen browser
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Apple fonts flake
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # Minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # Arr
    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux"];
      imports = [
        ./parts/lib.nix
        ./parts/overlays.nix
        ./parts/darwin.nix
        ./parts/nixos.nix
        ./parts/system-manager.nix
        ./parts/home-manager.nix
      ];
      perSystem = {pkgs, ...}: {
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
