{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeScriptBin "bs" ''
      #!${runtimeShell}
      if [ "$1" = "u" ]
      shift
      then
        args=(--update-input darwin --update-input home --update-input utils)
        if [ -n "$1" ]
        then
          args+=(--override-input nixpkgs "github:NixOS/nixpkgs/$1")
        else
          args+=(--update-input nixpkgs)
        fi
        nix flake lock ''${args[@]}
        shift
      fi
      darwin-rebuild switch --flake ~/.config/nixpkgs "''$@"
    '')
    coreutils-full
    daemon
    darwin.iproute2mac
    pstree
    subfinder

    browserpass
    zbar
    dockutil

    nodejs
    nodePackages.pnpm
    nodePackages.yarn

    gitui

    wakatime

    mkcert
    ddev

    platformsh
    neofetch
    cachix

    ueberzugpp
  ];
}
