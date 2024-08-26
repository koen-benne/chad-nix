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

  # Can be removed once https://github.com/LnL7/nix-darwin/pull/942 is merged
  imports = [
    inputs.nh_darwin.nixDarwinModules.prebuiltin
  ];

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      # Installation option once https://github.com/LnL7/nix-darwin/pull/942 is merged:
      # package = inputs.nh_darwin.packages.${pkgs.system}.default;
      # Hopefully in the future package will be nh_darwin by default so that this can be moved to common
    };
    hm.my.nix-helper.enable = true;
  };
}
