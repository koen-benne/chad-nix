{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.globalprotect;
  dmsCfg = sys.my.dankmaterialshell;

  # Determine gpclient path based on whether it's NixOS or standalone
  gpclientPath =
    if sys.my.globalprotect.enable
    then "${pkgs.gpclient}/bin/gpclient"  # NixOS: use system package path
    else "${config.home.homeDirectory}/.nix-profile/bin/gpclient";  # Standalone: use home-manager path

  # Substitute the gpclient path in the plugin
  pluginWithPath = pkgs.runCommand "globalprotect-control-plugin"
    {
      gpclient = gpclientPath;
    } ''
    mkdir -p $out
    cp -r ${./dms-plugin}/* $out/
    chmod -R +w $out
    substituteInPlace $out/Main.qml \
      --replace "@gpclient@" "$gpclient"
  '';
in {
  config = mkIf cfg.enable {
    # Install custom GlobalProtect Control plugin for DankMaterialShell if DMS is enabled
    xdg.configFile."DankMaterialShell/plugins/globalprotect-control" = mkIf dmsCfg.enable {
      source = pluginWithPath;
      recursive = true;
    };
  };
}
