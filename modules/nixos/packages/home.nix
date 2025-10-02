# All nixos systems will have these packages
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    steamcmd
    steam-run
    iotop
    hdparm
  ];
}
