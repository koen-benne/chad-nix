{ config, lib, pkgs, ... }:

with lib;

{
  options.my = {
    systemPath = mkOption { type = types.str; };
    keys = mkOption { type = types.listOf types.str; };
  };
  config = {
    my = {
      systemPath = builtins.replaceStrings
        [ "$HOME" "$USER" ] [ "/Users/${config.my.user}" config.my.user ]
        config.environment.systemPath;
      # Authorized keys
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxi9At1p43peTX3rwPFe224xA2JJ8G+Eq72ttJwT+J3 koen.benne@gmail.com"
      ];
    };
  };
}
