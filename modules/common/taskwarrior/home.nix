{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.taskwarrior;
in {
  options.my.taskwarrior = {
    enable = mkEnableOption (mdDoc "taskwarrior");
  };

  config = mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.unstable.taskwarrior3;
    };
  };
}
