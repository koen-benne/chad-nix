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
    (pass.withExtensions (ext: [ext.pass-otp ext.pass-audit]))
    (writeScriptBin "nvim-update" ''
      #!${runtimeShell}
      cd $HOME/.config/chad-nix
      nix flake lock --update-input neovim
      sudo nixos-rebuild switch --flake .
    '')
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
    nerd-fonts.jetbrains-mono
    nmap
    rippkgs
    # nvim-pkg # Custom neovim build
    comma # for entering shells with packages

    unstable.nodejs
    # nodePackages.pnpm
    # nodePackages.yarn

    dev-utils # from dev-flakes overlay

    unstable._1password-cli
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
    taskwarrior.enable = true;
    nix-helper.enable = true;
  };
}
