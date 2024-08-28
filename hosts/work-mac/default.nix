{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "RQG5XMDJF4";

  # Everythhing desktop related
  my.desktop.enable = true;

  # Stuff specific to only this machine
  my.openssl.enable = true;
  my.nix-helper.enable = true;
  # hm.my.qutebrowser.enable = true;
}
