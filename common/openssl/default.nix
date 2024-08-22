{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.openssl;
in {
  options.my.openssl = {
    enable = mkEnableOption (mdDoc "openssl");
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [
      "${config.my.home}/.local/share/mkcert/rootCA.pem"
    ];
  };
}
