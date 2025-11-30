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
  my.desktop.windowManager = "aerospace";
  # NOTE: Nix store app paths are automatically converted to mac-app-util trampolines
  # to prevent macOS from losing app data on every rebuild
  my.desktop.entries = [
    {path = "${pkgs.wezterm}/Applications/WezTerm.app";}
    {path = "${config.hm.programs.spicetify.spicedSpotify}/Applications/Spotify.app";}
    {
      path = "${config.my.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];

  # Stuff specific to only this machine
  my.openssl.enable = true;
}
