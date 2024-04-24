# All nixos systems will have these packages, perhaps this should be moved to system/default.nix
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    man-pages
    nixos-option
  ];
}
