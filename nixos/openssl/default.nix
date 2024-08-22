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
    systemd.services.mkcert = {
      description = "Install mkcert CA";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.mkcert ];
      serviceConfig = {
        ExecStart = ''
          if [ ! -f ${config.my.home}/.local/share/mkcert/rootCA.pem ]; then
            mkcert -install
          fi
        '';
        User = config.my.user;
        Type = "oneshot";
      };
    };

    security.pki.certificateFiles = [
      "${config.my.home}/.local/share/mkcert/rootCA.pem"
    ];
  };
}

