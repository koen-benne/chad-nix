{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ../../modules/common/my/default.nix

    # Modules that use companion modules (require sys.* options)
    ../../modules/common/desktop/home.nix
    ../../modules/common/hyprland/home.nix

    # Standalone modules (work independently)
    ../../modules/common/direnv/home.nix
    ../../modules/common/fish/home.nix
    ../../modules/common/git/home.nix
    ../../modules/common/gitui/home.nix
    ../../modules/common/gnupg/home.nix
    ../../modules/common/lazygit/home.nix
    ../../modules/common/neovim/home.nix
    ../../modules/common/nix-helper/home.nix
    ../../modules/common/ssh/home.nix
    ../../modules/common/taskwarrior/home.nix
    ../../modules/common/tmux/home.nix
    ../../modules/common/yazi/home.nix
    ../../modules/common/zsh/home.nix
  ];

  # Basic home configuration
  home.stateVersion = "24.05";

  # Enable desktop features
  sys.my.desktop.enable = true;
  sys.my.hyprland.enable = true;

  # nixGL for graphics acceleration on non-NixOS
  home.packages = [
    pkgs.home-manager
    inputs.nixgl.packages.${pkgs.system}.nixGLIntel
  ];

  # Enable core programs
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "Koen Benne";
    userEmail = "koen.benne@iodigital.com";
  };
  programs.tmux.enable = true;
  programs.fish.enable = true;
}
