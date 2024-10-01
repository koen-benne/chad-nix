{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.my.home}/.config/sops/age/keys.txt";

    secrets.github_token = {
      sopsFile = ./secrets/secrets.yaml;
      owner = config.my.user;
    };
  };
}
