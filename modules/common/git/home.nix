{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.git;
in {
  options.my.git = {
    enable = mkEnableOption (mdDoc "git");
  };

  config = mkIf cfg.enable {
    # home.packages = with pkgs; [
    #   git-crypt
    #   git-remote-gcrypt
    # ];
    programs.git = {
      enable = true;
      userEmail = config.my.email;
      userName = config.my.name;
      aliases = {
        br = "branch";
        ci = "commit";
        co = "checkout";
        cp = "cherry-pick";
        di = "diff";
        st = "status";

        fixup = "!sh -c 'git commit --fixup=$1 && git rebase --interactive --autosquash $1~' -";
        gch = "!sh -c 'git reflog expire --expire=now --all && git gc --prune=now --aggressive'";
        lg = "log --abbrev-commit --graph --date=relative --pretty=format:'%C(yellow)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset'";
        rewind = "!sh -c 'git update-ref refs/heads/$1 \${2:-HEAD}' -";
        amend = "commit --amend --no-edit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        graph = "log --graph --oneline --decorate --all";
        force = "push --force-with-lease";
        clean-branches = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
      };
      ignores = [
        ".*.sw?"
        ".direnv/"
        ".envrc"
        ".stignore"
      ];
      extraConfig = {
        core = {
          autocrlf = "input";  # Fuck Windows line endings
          ignorecase = false;
        };
        init.defaultBranch = "main";
        pull = {
          rebase = true; # Rebase on pull by default
          ff = "only";
        };
        push = {
          default = "simple";
          autoSetupRemote = true;  # Set up remote branch on new branch push
        };
        merge.ff = false;  # Always create merge commits for explicit merges
        branch.autoSetupRebase = "always";
        fetch.prune = true;
        diff.tool = "nvimdiff";
        rebase = {
          autosquash = true;
          autostash = true;
          stat = true;
        };
        rerere = {
          autoupdate = true;
          enabled = true;
        };
        status = {
          submoduleSummary = true;
          showUntrackedFiles = "all";  # Show untracked files in subdirs
        };

        # Quality of life improvements
        help.autoCorrect = 10;  # Auto-correct typos after 1 second
        commit.verbose = true;  # Show diff in commit message

        # Conditional includes for different directories
        includes = {
          path = "~/.config/git/gitconfig-work";
          condition = "gitdir:~/work/";
        };

        url = {
          "ssh://git@github.com:22/" = {pushInsteadOf = "https://github.com/";};
        };
      };
    };

    # Create work-specific git config in .config/git/
    home.file.".config/git/gitconfig-work".text = ''
      [user]
          email = ${config.my.workmail}
    '';
  };
}
