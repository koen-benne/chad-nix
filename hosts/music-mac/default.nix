{
  config,
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "music-mac";

  ids.gids.nixbld = 350;

  # Everything desktop related
  my.desktop.enable = true;

  # Stuff specific to only this machine
  my.openssl.enable = true;

  hm.my.opencode.enable = true;
}
