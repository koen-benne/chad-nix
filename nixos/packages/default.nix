# All nixos systems will have these packages
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man-pages
    nixos-option
  ];
}
