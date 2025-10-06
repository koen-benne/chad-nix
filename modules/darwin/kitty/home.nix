{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.kitty;
in {
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      darwinLaunchOptions = [
        "--single-instance"
        "--directory=${config.my.home}"
      ];
      extraConfig = ''
        background_opacity 0.6
        hide_window_decorations titlebar-only
        font_family      JetBrainsMonoNL Nerd Font Mono
        font_size        15.0
        bold_font        auto
        italic_font      auto
        bold_italic_font auto
        window_padding_width 5

        remember_window_size no
        initial_window_width 300c
        initial_window_height 60c

        foreground   #ffffff
        background   #000408
        cursor       #c0cdc7

        color0       #073642
        color8       #08404f
        color1       #dc322f
        color9       #e35f5c
        color2       #859900
        color10      #9fb700
        color3       #b58900
        color11      #d9a400
        color4       #268bd2
        color12      #4ba1de
        color5       #d33682
        color13      #dc619d
        color6       #2aa198
        color14      #32c1b6
        color7       #eee8d5
        color15      #ffffff

        map cmd+enter no_op
      '';
    };
    programs.zsh.initExtra = ''
      # kitty shell integration
      if [[ -n $KITTY_INSTALLATION_DIR ]]; then
        export KITTY_SHELL_INTEGRATION="enabled"
        autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
        kitty-integration
        unfunction kitty-integration
      fi
    '';
  };
}
