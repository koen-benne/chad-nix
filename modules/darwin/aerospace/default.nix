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
        pkgs.aerospace
        pkgs.jq
      ];
    };

    fonts.packages = [inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro-nerd pkgs.unstable.sketchybar-app-font];

    # Hide the menu bar to make place for sketchybar
    system.defaults = {
      NSGlobalDomain = {
        _HIHideMenuBar = true;
      };
    };
  };
}
