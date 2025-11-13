#The whole "my" section needs to go, it can be defined in different places instead
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      inputs.nix-index-database.homeModules.nix-index
      # This is temporary untill there is a quickshell module in stable!!!
      inputs.home-manager-unstable.homeModules.programs.quickshell
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];

  home.stateVersion = "24.05";
  systemd.user.startServices = "sd-switch";
}
