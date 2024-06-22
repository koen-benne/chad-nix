{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    arkenfox-nix.url = "github:dwarfmaster/arkenfox-nixos";

    nvim-nix.url = "github:koen-benne/nvim-nix";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-bundle.flake = false;
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-darwin" "x86_64-linux" ];
      imports = [ ./flakes ];
    };
}
