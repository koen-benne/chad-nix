{
  config,
  lib,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.colima;
in {
  options.my.colima = {
    enable = mkEnableOption (mdDoc "colima");
  };

  config = mkIf cfg.enable {
    programs.fish = {
      interactiveShellInit = ''
        set -gx DOCKER_HOST "unix://$HOME/.colima/docker.sock"
      '';
    };
  };
}
