{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
in {
  imports = [
    inputs.aerospace.packages.aarch64-darwin.default
  ];
}
