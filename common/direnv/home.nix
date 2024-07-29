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
      nix-direnv.enable = true;
    };
    programs.fish.shellInitLast = ''

      direnv hook fish | source

    '';
  };
}
