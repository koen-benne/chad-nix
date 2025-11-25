{
  config,
  pkgs,
  inputs,
  ...
}: {
  networking.hostName = "RQG5XMDJF4";

  # Everythhing desktop related
  my.desktop.enable = true;
  my.desktop.windowManager = "aerospace";
  my.desktop.entries = [
    {path = "${inputs.zen-browser.packages."${pkgs.system}".beta}/Applications/Zen Browser.app";}
    {path = "${pkgs.wezterm}/Applications/WezTerm.app";}
    {path = "${config.hm.programs.spicetify.spicedSpotify}/Applications/Spotify.app";}
    {
      path = "${config.my.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];

  my.work.enable = true;

  # Stuff specific to only this machine
  my.openssl.enable = true;
  hm.my.colima.enable = true;
  # hm.my.qutebrowser.enable = true;
}
