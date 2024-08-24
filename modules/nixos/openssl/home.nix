{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.openssl;
  scripts = ./scripts;
in {
  options.my.openssl = {
    enable = mkEnableOption (mdDoc "openssl");
  };
  config = mkIf cfg.enable {
    home.file.".local/share/mkcert/rootCA.pem".source = ../../../certs/rootCA.pem;
  };
}
