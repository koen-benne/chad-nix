# TODO: move enable from my.desktop to common
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.desktop;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      openASAR
    ];
  };
}
