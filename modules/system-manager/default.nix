{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.my.getModules [./.];
  
  # Basic configuration for system-manager
  # This is the main entry point for system-manager configurations
}