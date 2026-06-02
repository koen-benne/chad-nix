{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.lazygit;
in {
  options.my.lazygit = {
    enable = mkEnableOption "lazygit";
  };
  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = false;
          activeBorderColor = ["green" "bold"];
          inactiveBorderColor = ["white"];
          optionsTextColor = ["blue"];
        };
      };
    };
  };
}
