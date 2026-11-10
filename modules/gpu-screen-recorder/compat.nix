{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.gpu-screen-recorder = {
    enable = mkEnableOption "gpu-screen-recorder";
  };
}
