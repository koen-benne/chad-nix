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
    # Create the API key file with sops
    sops.secrets.bonzai_api_key = {
      mode = "0400";
      owner = config.my.user;
    };
  };
}
