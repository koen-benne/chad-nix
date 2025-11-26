# https://gist.github.com/antifuchs/10138c4d838a63c0a05e725ccd7bccdd
#
# This module automatically converts Nix store app paths to mac-app-util trampolines.
# Trampolines are stable wrapper apps that prevent macOS from treating apps as "new"
# on every rebuild, which would cause data loss (databases, cookies, settings, etc.)
#
# You can specify Nix store paths directly in my.desktop.entries and they will be
# automatically converted to ~/Applications/Home Manager Trampolines/<AppName>.app
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types concatMapStrings hasSuffix;
  inherit (types) listOf submodule str;
  cfg = config.my.dock;
  stdenv = pkgs.stdenv;
in {
  options = {
    my.dock.enable = mkOption {
      description = "Enable dock";
      default = stdenv.isDarwin;
      example = false;
    };

    my.dock.entries =
      mkOption
      {
        description = "Entries on the Dock";
        type = listOf (submodule {
          options = {
            path = lib.mkOption {type = str;};
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
        readOnly = true;
      };
  };

  config =
    mkIf (cfg.enable)
    (
      let
        du = "sudo -u ${config.my.user} env PYTHONIOENCODING=utf-8 ${pkgs.dockutil}/bin/dockutil";
        normalize = path:
          if hasSuffix ".app" path
          then path + "/"
          else path;

        # Convert Nix store app paths to stable mac-app-util trampoline paths
        # This prevents macOS from losing app data on every rebuild
        toTrampolinePath = path:
          if hasSuffix ".app" path && lib.hasPrefix "/nix/store/" path
          then let
            appName = baseNameOf path;
          in "${config.my.home}/Applications/Home Manager Trampolines/${appName}"
          else path;

        entryURI = path:
          "file://"
          + (
            builtins.replaceStrings
            # TODO: This is entirely too naive and works only with the bundles that I have seen on my system so far:
            [" " "!" "\"" "#" "$" "%" "&" "'" "(" ")"]
            ["%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29"]
            (normalize (toTrampolinePath path))
          );
        wantURIs =
          concatMapStrings
          (entry: "${entryURI entry.path}\n")
          cfg.entries;
        createEntries =
          concatMapStrings
          (entry: "${du} --no-restart --add '${toTrampolinePath entry.path}' --section ${entry.section} ${entry.options}\n")
          cfg.entries;
      in {
        system.activationScripts.postActivation.text = ''
          echo >&2 "Setting up persistent dock items..."
          haveURIs="$(${du} --list | ${pkgs.coreutils}/bin/cut -f2)"
          if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2 ; then
            echo >&2 "Resetting Dock."
            ${du} --no-restart --remove all
            ${createEntries}
            killall Dock
          else
            echo >&2 "Dock is how we want it."
          fi
        '';
      }
    );
}
