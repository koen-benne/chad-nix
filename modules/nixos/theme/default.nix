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
    inputs.stylix.nixosModules.stylix
  ];

  # Stylix requires an image

  config = mkMerge [
    # Currently, image has to be set as soon as you import the module: https://github.com/danth/stylix/issues/200
    {
      stylix.image = ../../../assets/wp-ultrawide.png;
    }

    (mkIf cfg.enable {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
        polarity = "dark";
        cursor = {
          package = pkgs.adwaita-icon-theme;
          size = 16;
          name = "Adwaita";
        };
        fonts = {
          sansSerif = {
            package = pkgs.fira;
            name = "Fira Sans";
          };
          serif = {
            package = pkgs.poly;
            name = "Poly";
          };
          monospace = {
            package = pkgs.jetbrains-mono-nerdfont;
            name = "JetBrainsMonoNL Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-emoji;
            name = "Noto Color Emoji";
          };
        };
      };

      hm.my.theme.enable = true;

      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita";
      };
    })
  ];
}
