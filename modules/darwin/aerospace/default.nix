{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.desktop;
in {
  config = mkIf (cfg.windowManager == "aerospace") {
    services.sketchybar = {
      enable = true;
      extraPackages = [
        inputs.aerospace.packages.${pkgs.system}.default
        inputs.apple-fonts.packages.${pkgs.system}.sf-pro
        pkgs.sketchybar-app-font
        pkgs.jq
      ];
    };

    # Hide the menu bar to make place for sketchybar
    system.defaults = {
      NSGlobalDomain = {
        _HIHideMenuBar = true;
      };
    };
  };
}
