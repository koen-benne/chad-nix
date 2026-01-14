{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.my.spicetify;
in {
  options.my.spicetify = {
    enable = mkEnableOption (mdDoc "spicetify");
  };

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.spotdl
    ];

    programs.spicetify = {
      enable = false;
      theme = spicePkgs.themes.lucid;
      # colorScheme = "mocha";
      # alwaysEnableDevTools = true;

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        lyricsPlus
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];
    };
  };
}
