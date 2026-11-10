{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.nix-helper;
in {
  options.my.nix-helper = {
    enable = mkEnableOption "nix-helper";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
  };
}
