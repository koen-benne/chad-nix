{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Home-manager compatibility layer (provides sys.* options)
    ../../modules/home-manager-compat

    # Auto-discover all home.nix modules
    ../../modules/common/home.nix
    ../../modules/nixos/home.nix
  ];

  # Basic home configuration
  home.stateVersion = "24.05";
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nix;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Enable desktop features
  my.desktop.enable = true;
  my.hyprland.enable = true;

  # nixGL for graphics acceleration on non-NixOS
  home.packages = [
    pkgs.xdg-desktop-portal
    pkgs.home-manager
    inputs.nixgl.packages.${pkgs.system}.nixGLIntel
  ];

  # Enable core programs
  programs.direnv.enable = true;
  # programs.git = {
  #   enable = true;
  #   userName = "Koen Benne";
  #   userEmail = "koen.benne@iodigital.com";
  # };
  programs.tmux.enable = true;
  programs.fish.enable = true;
}
