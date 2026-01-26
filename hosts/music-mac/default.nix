{
  config,
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "music-mac";

  ids.gids.nixbld = 350;

  # Stuff specific to only this machine
  my.openssl.enable = true;

  my.opencode.enable = true;
}
