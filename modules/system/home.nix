{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };
}
