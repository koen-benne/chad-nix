# All systems will have these packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    gcc
    curl
    gnupg
    man
    openssh
    man-pages
    nixos-option
  ];

  my.mdns.enable = true;
}
