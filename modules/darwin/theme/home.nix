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

  # Stylix requires an image

  config = mkMerge [
    # Currently, image is not optional: https://github.com/danth/stylix/issues/200
    {
      stylix.image = ../../../assets/wp-normal.png;
    }

    (mkIf cfg.enable {
      stylix = {
        enable = true;
        targets = {
          neovim.enable = false;
          fzf.enable = false;
          spicetify.enable = false;
          # The line below can be removed when https://github.com/nix-community/stylix/pull/1316 is merged and backported
          gnome.enable = false;
        };
        base16Scheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
        polarity = "dark";
        opacity = {
          popups = 0.8;
          terminal = 0.7;
        };
      };
    })
  ];
}
