{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "music-mac";

  # Everythhing desktop related
  my.desktop.enable = true;
  my.desktop.windowManager = "aerospace";

  # Stuff specific to only this machine
  my.openssl.enable = true;
  my.nix-helper.enable = true;
  # hm.my.qutebrowser.enable = true;
}
