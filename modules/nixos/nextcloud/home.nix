{
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf sys.my.nextcloud.client.enable {
    home.packages = with pkgs; [
      nextcloud-client
    ];
  };
}
