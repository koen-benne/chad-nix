{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.openssl;
  scripts = ./scripts;
in {
  config = mkIf cfg.enable {
    home.file.".local/share/mkcert/rootCA.pem".source = ../../../certs/rootCA.pem;
  };
}
