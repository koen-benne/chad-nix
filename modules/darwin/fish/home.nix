{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.fish;
  current = ../..;
in {
  config = mkIf cfg.enable {
    programs.fish = {
      shellAliases = {
        darwin-switch = "darwin-rebuild switch --flake ${current}";
        darwin-update = "nix flake update ${current}";
      };
    };
  };
}
