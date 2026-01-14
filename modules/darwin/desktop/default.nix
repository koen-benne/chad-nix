{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.desktop;
in {
  config = mkIf cfg.enable {
    # my.kitty.enable = true;
    hm.my.wezterm.enable = true;
    hm.my.theme.enable = true;
  };
}
