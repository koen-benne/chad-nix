{ config, inputs, lib, pkgs, ... }:
let
  inherit (lib) mdDoc mkEnableOption mkIf;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  cfg = config.my.spicetify;
in
{
  options.my.spicetify = {
    enable = mkEnableOption (mdDoc "spicetify");
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.Onepunch;
      # colorScheme = "frappe";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
      ];
    };
  };
}
