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
    # Import only common home modules that don't depend on system config
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
  systemd.user.startServices = "sd-switch";
  
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