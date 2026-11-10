{
  inputs,
  lib,
  ...
}: {
  imports =
    [
      inputs.nix-index-database.homeModules.nix-index
    ]
    ++ lib.my.getHmModules [./.];

  home.stateVersion = "26.05";
  systemd.user.startServices = "sd-switch";
}
