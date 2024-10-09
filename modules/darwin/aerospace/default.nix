{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf (cfg.windowManager == "aerospace") {
    services.sketchybar = {
      enable = true;
      extraPackages = [
        inputs.aerospace.packages.aarch64-darwin.default
        pkgs.sketchybar-app-font
        pkgs.jq
      ];
    };

    hm.my.aerospace.enable = true;
  };
}
