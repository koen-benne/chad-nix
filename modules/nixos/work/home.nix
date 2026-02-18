{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf optional;
  cfg = config.my.work;
in {
  options.my.work = {
    enable = mkEnableOption (mdDoc "work");
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # globalprotect-openconnect
      teams-for-linux
      slack

      notesnook
      obsidian
    ];
  };
}
