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

    # Create the API key file with sops
    sops.secrets.bonzai-api-key = {
      sopsFile = ./secrets.yaml;
      path = "${config.my.home}/.config/opencode/bonzai-key";
      mode = "0600";
    };

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
