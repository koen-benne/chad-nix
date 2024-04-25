{ config, lib, pkgs, ... }:

with lib;

{
  options.my = {
    user = mkOption { type = types.str; };
    name = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    workmail = mkOption { type = types.str; };
    uid = mkOption { type = types.int; };
  };
  config.my = {
    user = "koenbenne";
    name = "Koen Benne";
    email = "koen.benne@gmail.com";
    workmail = "koen.benne@iodigital.com";
    uid = 1000;
  };
}
