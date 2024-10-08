{
  inputs,
  pkgs,
  ...
}: {
  services.sketchybar = {
    enable = true;
    extraPackages = [
      inputs.aerospace.packages.aarch64-darwin.default
      pkgs.sketchybar-app-font
      pkgs.jq
    ];
  };
}
