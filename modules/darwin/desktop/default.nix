{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mdDoc mkIf;
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    enable = mkEnableOption (mdDoc "desktop");
  };

  config = mkIf cfg.enable {
    # my.kitty.enable = true;
    hm.my.wezterm.enable = true;
    hm.my.theme.enable = true;
  };
}
