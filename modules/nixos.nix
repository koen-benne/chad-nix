{
  inputs,
  config,
  lib,
  ...
}: {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
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
