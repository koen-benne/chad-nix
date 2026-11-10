{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home-manager-standalone.nix
  ];

  # Basic home configuration
  home.stateVersion = "26.05";
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
    # package = inputs.determinate.packages.${pkgs.system}.default;
    package = pkgs.nix;
  };

  # Enable desktop features
  my.desktop.enable = true;
  my.desktop.windowManager = "niri";
  my.work.enable = true;

  # Core programs are enabled by the shared packages home module
  # - direnv, git, tmux, fish, zsh, etc. all enabled via my.* options
}
