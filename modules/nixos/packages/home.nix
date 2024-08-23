# All nixos systems will have these packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  ];
}
