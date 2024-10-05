{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.aerospace.packages.aarch64-darwin.default
    pkgs.sketchybar
    pkgs.sketchybar-app-font
  ];
}
