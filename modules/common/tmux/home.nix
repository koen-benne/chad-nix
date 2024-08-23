{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.tmux;
in {
  options.my.tmux = {
    enable = mkEnableOption (mdDoc "tmux");
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      prefix = "C-s";
      extraConfig = ''
        set -ga terminal-overrides ",screen-256color*:Tc"
        set-option -g default-terminal "screen-256color"
        set -s escape-time 0
        set -gq allow-passthrough on

        bind-key C-a send-prefix
        set -g status-style 'bg=#333333 fg=#5eacd3'

        set-window-option -g mode-keys vi
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

        # vim-like pane switching
        bind -r ^ last-window
        bind -r k select-pane -U
        bind -r j select-pane -D
        bind -r h select-pane -L
        bind -r l select-pane -R

        # window switching
        bind -r t new-window
        bind -r w kill-window
        bind -r q confirm -p "Kill this tmux session?" kill-session
        bind -r n next-window
        bind -r p previous-window

        # use tmux like god intended
        bind-key -r f run-shell "tmux neww turbotmux project"
        bind-key -r o run-shell "tmux neww turbotmux open"
        bind-key -r c run-shell "tmux neww turbotmux close"
      '';
    };
  };
}
