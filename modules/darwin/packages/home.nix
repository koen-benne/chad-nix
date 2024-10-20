# All darwin systems will have these packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # (writeScriptBin "bs" ''
    #   #!${runtimeShell}
    #   if [ "$1" = "u" ]
    #   shift
    #   then
    #     args=(--update-input darwin --update-input home --update-input utils)
    #     if [ -n "$1" ]
    #     then
    #       args+=(--override-input nixpkgs "github:NixOS/nixpkgs/$1")
    #     else
    #       args+=(--update-input nixpkgs)
    #     fi
    #     nix flake lock ''${args[@]}
    #     shift
    #   fi
    #   darwin-rebuild switch --flake ~/.config/nixpkgs "''$@"
    # '')
    coreutils-full
    daemon
    darwin.iproute2mac
    pstree
    subfinder

    browserpass
    ueberzugpp
    zbar
    raycast
    spotify

    wakatime

    neofetch
    cachix

    # MacOS comes with bash from the stone age. This version does not support certain features
    bash
  ];
  my.syncthing.enable = true;
}
