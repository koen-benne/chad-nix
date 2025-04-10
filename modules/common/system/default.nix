{
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings = {
    auto-optimise-store = lib.mkDefault true;
    extra-experimental-features = ["flakes" "nix-command"];
    keep-outputs = true;
    log-lines = 25;
    tarball-ttl = 43200;
    trusted-users = ["root" config.my.user];
    # Seems like a darwin module for sops-nix is needed for this to work
    # https://github.com/Mic92/sops-nix/pull/614
    # access-tokens = "github.com=${config.sops.placeholder.github_access_token}";
  };
  nix.package = pkgs.nix;
  programs.fish.enable = true;
  time.timeZone = "Europe/Amsterdam";

  environment.variables = {
    NH_FLAKE = "${config.my.home}/.config/chad-nix";
  };
}
