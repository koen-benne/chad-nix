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
      extraConfig = ''
        local wezterm = require 'wezterm'
        local config = wezterm.config_builder()

        config.font_size = 15.0
        config.window_decorations = "RESIZE"
        config.hide_tab_bar_if_only_one_tab = true
        config.window_background_opacity = 0.6
        config.macos_window_background_blur = 20
        config.colors = {
          foreground = "#ffffff",
          background = "#000408"
        }
        config.font = wezterm.font { family = "JetBrainsMonoNL Nerd Font Mono" }

        return config
      '';
    };
  };
}
