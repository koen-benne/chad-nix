{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    man-pages
    nixos-option
  ];
}
