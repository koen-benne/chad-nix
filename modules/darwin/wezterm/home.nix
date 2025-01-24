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
        -- Fixes https://github.com/wez/wezterm/issues/6005
        config.front_end = "WebGpu"
        config.window_decorations = "RESIZE"
        config.hide_tab_bar_if_only_one_tab = true
        config.macos_window_background_blur = 20

        config.default_cursor_style = 'SteadyBar'

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

        wezterm.on("gui-startup", function(cmd)
          if cmd == nil then return end
          local args = cmd.args
          for i, arg in ipairs(args) do
            if arg == "passinator" or arg == "appfzf" then
              local screen = wezterm.gui.screens().active
              local width = 500
              local height = 500

              local tab, pane, window = wezterm.mux.spawn_window{ args = args }
              window:set_title("centered")
              window:gui_window():set_inner_size(width, height)
              window:gui_window():set_position(
                math.floor((screen.width - width) / 2),
                math.floor((screen.height - height) / 2)
              )
              return
            end
          end
        end)

        wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
          -- Make sure windows will be named centered if they are set to centered
          if tab.window_title == "centered" then
            return "centered"
          end

          -- The default functionality below
          local zoomed = ""
          if tab.active_pane.is_zoomed then
            zoomed = "[Z] "
          end
          local index = ""
          if #tabs > 1 then
            index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
          end
          return zoomed .. index .. tab.active_pane.title
        end)

        return config
      '';
    };
  };
}
