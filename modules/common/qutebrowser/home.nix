{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.qutebrowser;
  config = builtins.readFile ./config.py;
in {
  options.my.qutebrowser = {
    enable = mkEnableOption (mdDoc "qutebrowser");
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      extraConfig = "${config}";
      greasemonkey.enable = true;
      extensions = [
        "greasemonkey"
        "user-css@userchromejs.org"
      ];
    };
  };
}
