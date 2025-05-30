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

        config.font_size = 14.0
        -- Fixes https://github.com/wez/wezterm/issues/6005
        config.front_end = "WebGpu"
        config.window_decorations = "RESIZE"
        config.hide_tab_bar_if_only_one_tab = true
        config.macos_window_background_blur = 20

        config.default_cursor_style = 'SteadyBar'
        config.warn_about_missing_glyphs = false

        config.colors = {
          foreground = "#ffffff",
          background = "#000408",
          cursor_bg = "#c0cdc7",
          cursor_border = "#c0cdc7",

          ansi = {
            '#073642', -- black
            '#dc322f', -- maroon
            '#859900', -- green
            '#b58900', -- olive
            '#268bd2', -- navy
            '#d33682', -- purple
            '#2aa198', -- teal
            '#eee8d5', -- silver
          },

          brights = {
            '#08404f', -- grey
            '#e35f5c', -- red
            '#9fb700', -- lime
            '#d9a400', -- yellow
            '#4ba1de', -- blue
            '#dc619d', -- fuchsia
            '#32c1b6', -- aqua
            '#ffffff', -- white
          }
        }
        config.font = wezterm.font { family = "JetBrainsMonoNL Nerd Font Mono" }

        return config
      '';
    };
  };
}
