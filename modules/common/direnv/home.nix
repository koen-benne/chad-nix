{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.direnv;
in {
  options.my.direnv = {
    enable = mkEnableOption (mdDoc "direnv");
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
