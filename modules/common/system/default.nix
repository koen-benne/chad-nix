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
  };
  nix.package = pkgs.nix;
  programs.fish.enable = true;
  time.timeZone = "Europe/Amsterdam";

  environment.variables = {
    NH_FLAKE = "${config.my.home}/.config/chad-nix";
  };
}
