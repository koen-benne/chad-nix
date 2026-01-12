{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.my.theme = {
    enable = mkEnableOption "system theme configuration";
  };

  imports = [
    inputs.stylix.homeModules.stylix
  ];

  # Provide the actual theme configuration for home-manager standalone mode
  config = mkIf config.my.theme.enable {
    # TODO: find out why we need this.
    dconf.enable = false;

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
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    # Add comprehensive Unicode fallback fonts
    fonts.fontconfig.defaultFonts = {
      monospace = [
        "JetBrainsMonoNL Nerd Font"
        "Noto Sans Mono"
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "Fira Sans"
        "Noto Sans"
        "DejaVu Sans"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };

    # Install fallback fonts with good Unicode coverage
    home.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      dejavu_fonts
    ];
  };
}
