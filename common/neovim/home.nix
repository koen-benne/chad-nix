{ config, lib, pkgs, ... }:

{
  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      extraLuaPackages = ps: [ ps.magick ];
    };
  };
}
