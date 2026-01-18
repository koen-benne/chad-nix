{
  inputs = {
    # Package sources
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";


    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "unstable";

    # arkenfox-nix.url = "github:dwarfmaster/arkenfox-nixos";

    neovim.url = "github:koen-benne/neovim";
    neovim.inputs.nixpkgs.follows = "unstable";

    dev-flakes.url = "github:koen-benne/dev-flakes";
    dev-flakes.inputs.nixpkgs.follows = "unstable";

    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;

    # Determinate Nix
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # Secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Zen browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    # Apple fonts flake
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # Minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # Hytale server (runtime-auth downloader)
    nix-hytale-server.url = "github:OsiPog/nix-hytale-server";
    nix-hytale-server.inputs.nixpkgs.follows = "nixpkgs";

    # Arr
    nixarr.url = "github:rasmus-kirk/nixarr";

    # Niri wayland compositor (using very-refactor branch for v25.11)
    niri.url = "github:sodiboo/niri-flake/very-refactor";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    # Mango wayland compositor
    mango.url = "github:DreamMaoMao/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";

    # DankMaterialShell (bar etc.)
    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "unstable";
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
