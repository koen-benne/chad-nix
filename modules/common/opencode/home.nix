{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.opencode;
in {
  options.my.opencode = {
    enable = mkEnableOption (mdDoc "opencode");
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.unstable.opencode
    ];

    xdg.configFile = {
      "opencode/opencode.json" = {
        source = ./opencode.json;
      };
      "opencode/plugin/bonzai-remove-unsupported-params.ts" = {
        source = ./bonzai-remove-unsupported-params.ts;
      };
    };
  };
}

