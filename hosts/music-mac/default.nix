{
  config,
  system,
  pkgs,
  ...
}: {
  networking.hostName = "music-mac";

  ids.gids.nixbld = 350;

  # Everythhing desktop related
  my.desktop.enable = true;
  my.desktop.windowManager = "aerospace";
  my.desktop.entries = [
    {path = "${pkgs.zen-browser.packages."${system}".beta}/Applications/Zen Browser.app";}
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
  # hm.my.qutebrowser.enable = true;
}
