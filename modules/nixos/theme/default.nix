{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.theme;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/railscasts.yaml";
      image = ../../../assets/wp-ultrawide.png;
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
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMonoNL Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    hm.my.theme.enable = true;
  };
}
