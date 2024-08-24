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
    launchd.daemons.mkcert = {
      description = "Install mkcert CA";
      wantedBy = ["multi-user.target"];
      path = [pkgs.mkcert pkgs.nss];
      serviceConfig = {
        ExecStart = ''
          if [ ! -f "${config.my.home}/Library/Application Support/mkcert/rootCA.pem" ]; then
            mkcert -install
          fi
        '';
        UserName = config.my.user;
        Type = "oneshot";
      };
    };
  };
}
