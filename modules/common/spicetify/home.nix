{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  cfg = config.my.spicetify;
in {
  options.my.spicetify = {
    enable = mkEnableOption (mdDoc "spicetify");
  };

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      # This is now managed by stylix
      # theme = spicePkgs.themes.onepunch;
      # colorScheme = "frappe";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
      ];
    };
  };
}
