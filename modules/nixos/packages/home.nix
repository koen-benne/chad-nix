# All nixos systems will have these packages
{pkgs, ...}: {
  home.packages = with pkgs; [
    # steamcmd # Temporarily disabled due to download failures from Steam CDN
    steam-run
    iotop
    hdparm
  ];
}
