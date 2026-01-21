{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.globalprotect;
in {
  options.my.globalprotect = {
    enable = mkEnableOption (mdDoc "GlobalProtect VPN client");
  };

  config = mkIf cfg.enable {
    # Install gpclient via home-manager for standalone mode
    home.packages = [
      pkgs.gpclient
    ];
  };
}
