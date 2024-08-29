{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.wezterm;
in {
  options.my.wezterm = {
    enable = mkEnableOption (mdDoc "wezterm");
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
    };
  };
}
