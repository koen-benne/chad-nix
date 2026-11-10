{
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [
      ./home.nix
    ]
    ++ lib.my.getCompatModules [./.];

  config = {
    targets.genericLinux.enable = true;
    targets.genericLinux.gpu.enable = true;
    fonts.fontconfig.enable = true;

    my.isStandalone = true;
    _module.args.sys = config;

    nix.settings.nix-path = ["nixpkgs=${pkgs.path}"];
    home.sessionVariables.NIX_PATH = "nixpkgs=${pkgs.path}";
    home.packages = [pkgs.home-manager];
  };
}
