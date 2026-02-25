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
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  options.my.zen-browser = {
    enable = mkEnableOption (mdDoc "zen-browser");
  };

  config = mkIf cfg.enable {
    # Required for home-manager's Firefox/Zen module to work properly
    # This forces the legacy profile system that home-manager expects
    home.sessionVariables.MOZ_LEGACY_PROFILES = "1";

    xdg.mimeApps = let
      associations = builtins.listToAttrs (map (name: {
          inherit name;
          value = let
            zen-browser = config.programs.zen-browser.package;
          in
            zen-browser.meta.desktopFileName;
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

    programs.zen-browser = {
      enable = true;
      policies = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });

        mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry = {
          id,
          pinned ? false,
        }: let
          base = {
            install_url = mkPluginUrl id;
            installation_mode = "force_installed";
          };
        in
          if pinned
          then base // {default_area = "navbar";}
          else base;

        mkExtensionSettings = builtins.mapAttrs (_: entry:
          if builtins.isAttrs entry
          then entry
          else mkExtensionEntry {id = entry;});
      in {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        SanitizeOnShutdown = {
          FormData = true;
          Cache = true;
        };
        ExtensionSettings = mkExtensionSettings {
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = mkExtensionEntry {
            id = "1password-x-password-manager";
            pinned = true;
          };
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
          "{74145f27-f039-47ce-a470-a662b129930a}" = "clearurls";
          "github-no-more@ihatereality.space" = "github-no-more";
          "github-repository-size@pranavmangal" = "gh-repo-size";
          "firefox-extension@steamdb.info" = "steam-database";
          "@searchengineadremover" = "searchengineadremover";
          "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
          "trackmenot@mrl.nyu.edu" = "trackmenot";
          "{861a3982-bb3b-49c6-bc17-4f50de104da1}" = "custom-user-agent-revived";
          "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}" = "chameleon-ext";
        };
        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
          "browser.gesture.swipe.left" = "";
          "browser.gesture.swipe.right" = "";
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.topsites.contile.enabled" = false;

          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
          "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.spoof_english" = 1;

          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;

          "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true;
        };
      };

      profiles = {
        default = {
          id = 0; # Profile IDs must be sequential starting from 0
          isDefault = true; # Mark as default profile

          settings = {
            "zen.workspaces.continue-where-left-off" = true;
            "zen.workspaces.natural-scroll" = true;
            "zen.view.compact.hide-tabbar" = true;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.animate-sidebar" = false;
            "zen.welcome-screen.seen" = true;
            "zen.urlbar.behavior" = "float";
          };

          bookmarks = {
            force = true;
            settings = [
              {
                name = "Nix sites";
                toolbar = true;
                bookmarks = [
                  {
                    name = "homepage";
                    url = "https://nixos.org/";
                  }
                  {
                    name = "wiki";
                    tags = ["wiki" "nix"];
                    url = "https://wiki.nixos.org/";
                  }
                ];
              }
            ];
          };

          spacesForce = true;
          spaces = {
            "Communication" = {
              id = "c1a8f9e2-4b3d-4c8e-9f2a-1d3e5b7a9c4f";
              icon = "💬";
              position = 1000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    algorithm = "floating";
                    type = "explicit-lightness";
                    red = 0;
                    green = 120;
                    blue = 215;
                    lightness = 50;
                    position = {
                      x = 50;
                      y = 50;
                    };
                  }
                ];
                opacity = 0.5;
              };
            };
            "KNMI" = {
              id = "d2b9e0f3-5c4e-4d9f-8e3b-2e4f6c8d0a5e";
              icon = "🌤️";
              position = 2000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    algorithm = "floating";
                    type = "explicit-lightness";
                    red = 0;
                    green = 180;
                    blue = 220;
                    lightness = 55;
                    position = {
                      x = 50;
                      y = 50;
                    };
                  }
                ];
                opacity = 0.5;
              };
            };
            "StayOkay" = {
              id = "e3c0f1d4-6d5f-4e0g-9f4c-3f5g7d9e1b6f";
              icon = "🏨";
              position = 3000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    algorithm = "floating";
                    type = "explicit-lightness";
                    red = 255;
                    green = 140;
                    blue = 0;
                    lightness = 50;
                    position = {
                      x = 50;
                      y = 50;
                    };
                  }
                ];
                opacity = 0.5;
              };
            };
            "Zadkine" = {
              id = "f4d1e2c5-7e6g-5f1h-0g5d-4g6h8e0f2c7g";
              icon = "🎓";
              position = 4000;
              theme = {
                type = "gradient";
                colors = [
                  {
                    algorithm = "floating";
                    type = "explicit-lightness";
                    red = 0;
                    green = 150;
                    blue = 136;
                    lightness = 50;
                    position = {
                      x = 50;
                      y = 50;
                    };
                  }
                ];
                opacity = 0.5;
              };
            };
          };

          pinsForce = true;
          pins = {
            "Outlook" = {
              id = "a1b2c3d4-e5f6-47a8-b9c0-d1e2f3a4b5c6";
              workspace = "c1a8f9e2-4b3d-4c8e-9f2a-1d3e5b7a9c4f"; # Communication space
              url = "https://outlook.office365.com";
              isEssential = true;
              position = 100;
            };
            "GitHub" = {
              id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
              url = "https://github.com";
              position = 101;
              isEssential = false;
            };
          };

          containersForce = true;
          containers = {
            personal = {
              color = "purple";
              icon = "circle";
              id = 1;
              name = "Personal";
            };
          };

          search = {
            force = true;
            default = "google";
            engines = let
              nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            in {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = ["np"];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = ["nop"];
              };
              "Home Manager Options" = {
                urls = [
                  {
                    template = "https://home-manager-options.extranix.com/";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                      {
                        name = "release";
                        value = "master";
                      }
                    ];
                  }
                ];
                icon = nixSnowflakeIcon;
                definedAliases = ["hmop"];
              };
              bing.metaData.hidden = "true";
            };
          };
        };
      };
    };
  };
}
