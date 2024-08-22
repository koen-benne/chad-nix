{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.openssl;
in {
  config = mkIf cfg.enable {
    launchd.daemons.mkcert = {
      description = "Install mkcert CA";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.mkcert ];
      serviceConfig = {
        ExecStart = ''
          if [ ! -f "${config.my.home}/Library/Application Support/mkcert/rootCA.pem" ]; then
            mkcert -install
          fi
        '';
        UserName = config.my.username;
        Type = "oneshot";
      };
    };
  };
}
