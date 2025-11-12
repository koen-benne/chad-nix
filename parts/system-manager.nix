# Entry point when using system-manager switch
{
  inputs,
  withSystem,
  ...
}: let
  mkSystemManager = {
    system ? "x86_64-linux",
    modules ? [],
  }:
    withSystem system ({
      lib,
      pkgs,
      ...
    }:
      inputs.system-manager.lib.makeSystemConfig {
        extraSpecialArgs = {inherit inputs lib;};
        modules =
          [
            ../modules/system-manager
          ]
          ++ modules;
      });
in {
  flake.systemConfigs = {
    # Example system-manager configuration
    system-manager-example = mkSystemManager {
      modules = [../hosts/system-manager-example];
    };
    # Add your additional system-manager configurations here
  };
}
