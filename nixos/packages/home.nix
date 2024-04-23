{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    slack
    localsend
    ungoogled-chromium
    mpv
  ];
}
