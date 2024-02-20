{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mdDoc mkEnableOption mkIf;
in
{
  imports = lib.my.getHmModules [ ./. ];

  # my.zsh-ssh-agent.enable = true;
}
