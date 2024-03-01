{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-nixos.nix
  ];
  networking.hostName = "nixos";
  my.hyprland.enable = true;
  my.steam.enable = true;
  hm.my.zsh.enable = true;
  hm.my.foot.enable = true;
  hm.my.librewolf.enable = true;
  hm.my.spicetify.enable = true;
}
