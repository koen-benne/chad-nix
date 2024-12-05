{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkForce;
  cfg = config.my.theme;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  config = mkIf cfg.enable {
    stylix = {
      targets = {
        neovim.enable = false;
        waybar.enable = false;
        fuzzel.enable = false;
        fzf.enable = false;
      };
      opacity = {
        popups = 0.8;
        terminal = 0.7;
      };
    };
  };
}
