{
  inputs,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    inputs.aerospace.packages.aarch64-darwin.default
  ];

  # home.activation.aerospace = lib.hm.dag.entryAfter ["writeBoundary"] ("open ${inputs.aerospace.packages.aarch64-darwin.default}/AeroSpace.app");
  home.file = {
    ".config/sketchybar".source = ./sketchybar-config;
  };
  home.file = {
    ".config/aerospace".source = ./aerospace-config;
  };
}
