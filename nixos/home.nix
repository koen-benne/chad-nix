{ inputs, config, lib, pkgs, ... }:

{
  imports = [
  ] ++ lib.my.getHmModules [ ./. ];
}
