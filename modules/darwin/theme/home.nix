{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkMerge;
  cfg = config.my.theme;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  imports = [
    inputs.stylix.homeModules.stylix
  ];

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      # We have readonly packages
      overlays.enable = false;
      image = ../../../assets/wp-normal.png;
      targets = {
        neovim.enable = false;
        fzf.enable = false;
        spicetify.enable = false;
      };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
      polarity = "dark";
      opacity = {
        popups = 0.8;
        terminal = 0.7;
      };
    };
  };
}
