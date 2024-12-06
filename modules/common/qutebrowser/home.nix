{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.qutebrowser;
in {
  options.my.qutebrowser = {
    enable = mkEnableOption (mdDoc "qutebrowser");
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      settings = {
        tabs.position = "left";
        tabs.mousewheel_switching = false;
        tabs.new_position.unrelated = "next";
        tabs.select_on_remove = "prev";
        tabs.background = true;
      };
      extraConfig = ''
        if c.url.default_page == "":
            c.url.default_page = c.url.searchengines['DEFAULT']
        else:
            c.url.default_page += "${./index.html}"
        c.url.start_pages = [c.url.default_page]
      '';
      keyBindings = {
        normal = {
          "tt" = "config-cycle tabs.show always switching";
        };
      };
      # greasemonkey.enable = true;
      # extensions = [
      #   "greasemonkey"
      #   "user-css@userchromejs.org"
      # ];
    };
  };
}
