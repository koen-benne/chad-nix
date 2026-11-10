{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.taskwarrior;
in {
  options.my.taskwarrior = {
    enable = mkEnableOption "taskwarrior";
  };

  config = mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.unstable.taskwarrior3;
    };

    # Show tasks as fish greeting
    programs.fish.functions.fish_greeting = mkIf config.programs.fish.enable ''
      if command -v task &> /dev/null
        task 2>&1 | grep -v "No matches."
      end
    '';
  };
}
