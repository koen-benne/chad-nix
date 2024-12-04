{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.nix-helper;
in {
  options.my.nix-helper = {
    enable = mkEnableOption (mdDoc "nix-helper");
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
    };
  };
}
