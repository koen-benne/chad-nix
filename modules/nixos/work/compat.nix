{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.work;
in {
  options.my.work = {
    enable = mkEnableOption "work";
  };

  config = mkIf cfg.enable {
    my.globalprotect.enable = true;

    sops.secrets.bitbucket_api_token = {
      mode = "0400";
    };

    my.rails-dev.enable = true;
  };
}
