
# All systems will have these packages
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.neovim.homeModules.default
  ];

  programs.nvim = {
    categories = {
      general = true;
      debug.php = true;
      lspDebugMode = false;
      themer = true;
      colorscheme = "kanagawa";
    };
  };
}
