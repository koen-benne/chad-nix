{
  inputs,
  pkgs,
  ...
}: {
  services.sketchybar = {
    enable = true;
    extraPackages = [
      pkgs.sketchybar-app-font
      pkgs.jq
    ];
  };
}
