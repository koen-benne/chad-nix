{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.zen-browser;
in {
  options.my.zen-browser = {
    enable = mkEnableOption (mdDoc "zen-browser");
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser.enable = true;
    programs.zen-browser.policies = let
      mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      });
    in {
      ExtensionSettings = mkExtensionSettings {
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = "1password-x-password-manager";
      };
    };

    xdg.mimeApps = let
      value = let
        zen-browser = inputs.zen-browser.packages.${pkgs.system}.beta;
      in
        zen-browser.meta.desktopFileName;

      associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "application/x-extension-shtml"
          "application/x-extension-xhtml"
          "application/x-extension-html"
          "application/x-extension-xht"
          "application/x-extension-htm"
          "x-scheme-handler/unknown"
          "x-scheme-handler/mailto"
          "x-scheme-handler/chrome"
          "x-scheme-handler/about"
          "x-scheme-handler/https"
          "x-scheme-handler/http"
          "application/xhtml+xml"
          "application/json"
          "text/plain"
          "text/html"
        ]);
    in {
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
