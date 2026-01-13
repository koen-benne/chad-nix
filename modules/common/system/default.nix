{
  config,
  lib,
  pkgs,
  ...
}: {
  # Nix configuration is handled by Determinate Nix
  # Determinate Nix uses /etc/nix/nix.custom.conf for custom settings, so no conflicts
  nix.settings = {
    auto-optimise-store = true;
    extra-experimental-features = ["flakes" "nix-command"];
    keep-outputs = true;
    log-lines = 25;
    tarball-ttl = 43200;
    trusted-users = ["root" config.my.user];
    # Enable parallel evaluation using all available cores (Determinate Nix feature)
    eval-cores = 0;
    # Set nix-path to use flake's nixpkgs for <nixpkgs> lookups in nix-shell and legacy commands
    nix-path = ["nixpkgs=${pkgs.path}"];
  };
  nix.extraOptions = ''
    !include ${config.sops.secrets.github_access_token.path}
  '';
  # Don't override nix.package - let Determinate Nix manage itself
  programs.fish.enable = true;
  time.timeZone = "Europe/Amsterdam";

  environment.variables = {
    NH_FLAKE = "${config.my.home}/.config/chad-nix";
  };
}
