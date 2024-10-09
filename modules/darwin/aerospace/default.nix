{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mdDoc;
  cfg = config.my.aerospace;
in {
  options.my.aerospace = {
    enable = mkEnableOption (mdDoc "aerospace");
  };

  config = mkIf cfg.enable {
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
