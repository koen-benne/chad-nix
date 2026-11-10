{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.my.home}/.config/sops/age/keys.txt";

    secrets.github_access_token = {
      mode = "0440";
      owner = config.my.user;
    };
  };

  environment.systemPackages = with pkgs; [
    sops
  ];

  environment.variables = {
    SOPS_AGE_KEY_FILE = "${config.sops.age.keyFile}";
  };
}
