{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.neovim.homeModule
  ];

  nvim = {
    enable = true;
    packageDefinitions = {
      existing = "merge";
      merge = {
        nixCats = {
          settings = {
            wrapRc = true;
          };
        };
      };
    };
  };
}
