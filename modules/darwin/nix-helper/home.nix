{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.nix-helper;
in {
  options.my.nix-helper = {
    enable = mkEnableOption (mdDoc "nix-helper");
  };

  config = mkIf cfg.enable {
    home.shellAliases.nh = "nh_darwin";

    programs = mkIf config.my.fish.enable {
      fish.shellAliases.nh = "nh_darwin";
    };
  };

}
