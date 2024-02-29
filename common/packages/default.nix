{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    curl
    gnupg
    man
    openssh
  ];
}
