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
      inputs.nix-index-database.hmModules.nix-index
      ./my/default.nix
    ]
    ++ lib.my.getHmModules [./.];

  home.stateVersion = "24.05";
  systemd.user.startServices = "sd-switch";
}
