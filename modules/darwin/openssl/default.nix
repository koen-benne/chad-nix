{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.openssl;
in {
  options.my.openssl = {
    enable = mkEnableOption "openssl";
  };

  config =
    mkIf cfg.enable {
    };
}
