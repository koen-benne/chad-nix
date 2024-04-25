{ inputs, config, lib, pkgs, ... }:

{
  hm.imports = [
  ] ++ lib.my.getHmModules [ ./. ];
}
