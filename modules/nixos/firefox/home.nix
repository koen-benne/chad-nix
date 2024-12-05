{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
# Configured with help of https://github.com/dwarfmaster/arkenfox-nixos
let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.firefox;
  uc = builtins.readFile ./userChrome.css;
in {
  options.my.firefox = {
    enable = mkEnableOption (mdDoc "firefox");
  };

  imports = [
    inputs.arkenfox-nix.hmModules.arkenfox
  ];

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = true;
        version = "128.0";
      };

      profiles = {
        default = {
          arkenfox = {
            enable = true;
          };
          isDefault = true;
          name = "default";
          userChrome = uc;
        };
      };
      policies = {
        /*
        ---- EXTENSIONS ----
        */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # 1Password:
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium:
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
          # Darkreader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
          # MAL-Sync:
          "{c84d89d9-a826-4015-957b-affebd9eb603}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/mal-sync/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };
  };
}
