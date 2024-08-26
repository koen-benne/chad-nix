{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.openssl;
in {
  options.my.openssl = {
    enable = mkEnableOption (mdDoc "openssl");
  };

  config = mkIf cfg.enable {
  };
}
