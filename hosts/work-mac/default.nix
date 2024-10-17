{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "RQG5XMDJF4";

  # Everythhing desktop related
  my.desktop.enable = true;
  my.desktop.windowManager = "aerospace";
  my.desktop.entries = [
    {path = "/Applications/Arc.app/";}
    {path = "${pkgs.wezterm}/Applications/WezTerm.app/";}
    {path = "${pkgs.spotify}/Applications/Spotify.app/";}
    {
      path = "${config.my.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];

  my.work.enable = true;

  # Stuff specific to only this machine
  my.openssl.enable = true;
  my.nix-helper.enable = true;
  # hm.my.qutebrowser.enable = true;
}
