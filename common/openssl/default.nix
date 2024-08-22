{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.openssl = {
    enable = mkEnableOption (mdDoc "openssl");
  };

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [
      "${config.my.home}/.config/nixpkgs/certs/nixos-selfsigned.pem"
    ];
  };
}
