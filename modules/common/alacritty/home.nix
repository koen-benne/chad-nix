{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.alacritty;
in {
  options.my.alacritty = {
    enable = mkEnableOption (mdDoc "alacritty");
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.alacritty];
    xdg.configFile."alacritty/alacritty.toml".text = ''
      [colors.bright]
      black = "#4c566a"
      blue = "#81a1c1"
      cyan = "#8fbcbb"
      green = "#a3be8c"
      magenta = "#b48ead"
      red = "#bf616a"
      white = "#eceff4"
      yellow = "#ebcb8b"

      [colors.cursor]
      cursor = "#d8dee9"
      text = "#2e3440"

      [colors.dim]
      black = "#373e4d"
      blue = "#68809a"
      cyan = "#6d96a5"
      green = "#809575"
      magenta = "#8c738c"
      red = "#94545d"
      white = "#aeb3bb"
      yellow = "#b29e75"

      [colors.normal]
      black = "#3b4252"
      blue = "#81a1c1"
      cyan = "#88c0d0"
      green = "#a3be8c"
      magenta = "#b48ead"
      red = "#bf616a"
      white = "#e5e9f0"
      yellow = "#ebcb8b"

      [colors.primary]
      background = "#2e3440"
      dim_foreground = "#a5abb6"
      foreground = "#d8dee9"

      [colors.search.matches]
      background = "#88c0d0"
      foreground = "CellBackground"

      [colors.selection]
      background = "#4c566a"
      text = "CellForeground"

      [colors.vi_mode_cursor]
      cursor = "#d8dee9"
      text = "#2e3440"

      [font]
      size = 15.0

      [font.normal]
      family = "JetBrainsMonoNL Nerd Font Mono"

      [selection]
      save_to_clipboard = true

      [window]
      decorations = "buttonless"

      [window.dimensions]
      columns = 106
      lines = 29

      [window.position]
      x = 480
      y = 340
    '';
  };
}