{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.zellij;
in {
  options.my.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
    };

    # Alt-number tab switching + prefix bindings for turbozellij
    # f/o/c open floating panes that close automatically on exit
    # Start in locked mode to avoid accidental single-key triggers
    xdg.configFile."zellij/config.kdl".text = ''
      keybinds {
          normal {
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
              bind "Alt 0" { GoToTab 10; }
              bind "p" {
                  Run "turbozellij" "project" {
                      floating true
                      close_on_exit true
                      x "10%"
                      y "10%"
                      width "80%"
                      height "80%"
                  }
                  SwitchToMode "Locked";
              }
              bind "o" {
                  Run "turbozellij" "open" {
                      floating true
                      close_on_exit true
                      x "10%"
                      y "10%"
                      width "80%"
                      height "80%"
                  }
                  SwitchToMode "Locked";
              }
              bind "c" {
                  Run "turbozellij" "close" {
                      floating true
                      close_on_exit true
                      x "10%"
                      y "10%"
                      width "80%"
                      height "80%"
                  }
                  SwitchToMode "Locked";
              }
          }
          locked {
              bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
              bind "Alt 0" { GoToTab 10; }
          }
      }

      mouse_mode true
      copy_on_select true
      pane_frames false
      default_layout "bare"
      default_mode "locked"
      theme "default"
    '';

    xdg.configFile."zellij/layouts/bare.kdl".source = ./layouts/bare.kdl;

    xdg.configFile."zellij/layouts/dev.kdl".source = ./layouts/dev.kdl;

    programs.fish.shellAliases = {
      zo = "turbozellij open";
      zc = "turbozellij close";
      zp = "turbozellij project";
      zn = "turbozellij new";
    };
  };
}
