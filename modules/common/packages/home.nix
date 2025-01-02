# All systems will have these packages
{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (writeScriptBin "fp-update" ''
      #!${runtimeShell}
      rippkgs-index nixpkgs -o $HOME/.local/share/rippkgs-index.sqlite
    '')
    (pass.withExtensions (ext: [ext.pass-otp]))
    (writeScriptBin "nvim-update" ''
      #!${runtimeShell}
      cd $HOME/.config/chad-nix
      nix flake lock --update-input nvim-nix
      sudo nixos-rebuild switch --flake .
    '')
    (pass.withExtensions (ext: [ext.pass-otp]))
    age
    manix
    diffutils
    stow
    file
    findutils
    gawk
    gzip
    btop
    imagemagick
    ipcalc
    jq
    python3
    cargo
    ripgrep
    scripts
    jetbrains-mono-nerdfont
    nmap
    rippkgs
    nvim-pkg # Custom neovim build
    comma # for entering shells with packages

    nodejs
    # nodePackages.pnpm
    # nodePackages.yarn

    dev-utils # from dev-flakes overlay
  ];

  my = {
    direnv.enable = true;
    git.enable = true;
    lazygit.enable = true;
    gitui.enable = true;
    zsh.enable = true;
    fish.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };
}
