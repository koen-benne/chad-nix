{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.dms-greeter;
  desktopCfg = config.my.desktop;
in {
  imports = [
    inputs.dms.nixosModules.greeter
  ];

  options.my.dms-greeter = {
    enable = mkEnableOption (mdDoc "DankMaterialShell as greeter/login screen");
  };

  config = mkIf cfg.enable {
    # Enable greetd with DMS greeter
    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = desktopCfg.windowManager;
      # Copy user's DMS config (including wallpaper settings) to greeter
      configHome = config.my.home;
    };

    # Ensure the selected compositor is available
    assertions = [
      {
        assertion = cfg.enable -> (
          (desktopCfg.windowManager == "niri" && config.programs.niri.enable) ||
          (desktopCfg.windowManager == "hyprland" && config.programs.hyprland.enable) ||
          (desktopCfg.windowManager == "mango" && config.programs.mango.enable)
        );
        message = ''
          DMS greeter requires compositor '${desktopCfg.windowManager}' to be enabled.
          This should be configured via my.desktop.windowManager.
        '';
      }
    ];
  };
}

