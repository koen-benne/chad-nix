{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  imports =
    [
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];

  # my.zsh-ssh-agent.enable = true;
}
