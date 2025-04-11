{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.my.home}/.config/sops/age/keys.txt";

    secrets.github_access_token = { };
  };

  environment.systemPackages = with pkgs; [
    sops
  ];

  environment.variables = {
    SOPS_AGE_KEY_FILE = "${config.sops.age.keyFile}";
  };
}
