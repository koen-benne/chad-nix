{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.theme;
in {
  config = mkIf cfg.enable {
    stylix = {
      targets = {
        hyprland.enable = false;
        hyprpaper.enable = false;
        neovim.enable = false;
        fzf.enable = false;
        spicetify.enable = false;
        zen-browser.enable = false;
        qt = {
          enable = true;
          platform = "adwaita";
        };
      };
      opacity = {
        popups = 0.8;
        terminal = 0.7;
      };
    };
  };
}
