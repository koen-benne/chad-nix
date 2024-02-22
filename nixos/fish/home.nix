{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.my.fish;
  current = ../..;
in
{
  config = mkIf cfg.enable {
    programs.fish = {
      shellAliases = {
        nixos-switch = "nixos-rebuild switch --flake ${current}";
        nixos-update = "nix flake update ${current}";
      };
    };
  };
}
