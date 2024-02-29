{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    man-pages
    nixos-option
    polkit
    wl-clipboard
    openrgb
    i2c-tools
  ];
}
