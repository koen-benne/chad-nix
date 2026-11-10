{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.my = {
    user = mkOption {type = types.str;};
    name = mkOption {type = types.str;};
    domain = mkOption {type = types.str;};
    email = mkOption {type = types.str;};
    workmail = mkOption {type = types.str;};
    uid = mkOption {type = types.int;};
    systemPath = mkOption {type = types.str;};
    home = mkOption {type = types.str;};
    keys = mkOption {type = types.listOf types.str;};
    isStandalone = mkOption {
      type = types.bool;
      default = false;
      description = "Whether running in home-manager standalone mode";
    };
  };
  config = {
    my = {
      user = "koenbenne";
      name = "Koen Benne";
      domain = "dorkoe.nl";
      email = "koen.benne@gmail.com";
      workmail = "koen.benne@iodigital.com";
      uid = 1000;
      home = "/home/${config.my.user}";
      systemPath =
        builtins.replaceStrings
        ["$HOME" "$USER"] ["/home/${config.my.user}" config.my.user]
        config.environment.systemPath;
      # Authorized keys
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxi9At1p43peTX3rwPFe224xA2JJ8G+Eq72ttJwT+J3 koen.benne@gmail.com"
      ];
    };
  };
}
