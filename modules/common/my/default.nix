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
    isStandalone = mkOption {
      type = types.bool;
      default = false;
      description = "Whether running in home-manager standalone mode (not NixOS/Darwin)";
    };
  };
  config.my = {
    user = "koenbenne";
    name = "Koen Benne";
    domain = "dorkoe.nl";
    email = "koen.benne@gmail.com";
    workmail = "koen.benne@iodigital.com";
    uid = 1000;
  };
}
