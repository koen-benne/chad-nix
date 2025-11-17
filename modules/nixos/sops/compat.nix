{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.my.home}/.config/sops/age/keys.txt";
  };

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.sops.age.keyFile}";
  };

  home.packages = [
    config.pkgs.sops
  ];
}
