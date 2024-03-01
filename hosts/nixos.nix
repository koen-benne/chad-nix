{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-nixos.nix
  ];
  networking.hostName = "nixos";
  hm.my.zsh.enable = true;
  my.hyprland.enable = true;
  hm.my.foot.enable = true;
  hm.my.librewolf.enable = true;
  hm.my.spicetify.enable = true;
}
