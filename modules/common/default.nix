{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.my.user])
    ]
    ++ lib.my.getModules [./.];

  hm.imports = [
    ./home.nix
  ];

  home-manager.extraSpecialArgs = {
    inherit inputs;
    sys = config;
  };
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
}
