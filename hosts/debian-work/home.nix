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
      experimental-features = ["nix-command" "flakes"];
    };
    package = inputs.determinate.packages.${pkgs.system}.default;
  };

  # Enable desktop features
  my.desktop.enable = true;
  my.desktop.windowManager = "niri";


  # Core programs are enabled by common/packages/home.nix
  # - direnv, git, tmux, fish, zsh, etc. all enabled via my.* options
}
