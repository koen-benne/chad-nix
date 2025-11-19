{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".ssh/config".text = ''


    # Host backend.acc.natuurmonumenten.cloud.intracto.com
    #   HostName backend.acc.natuurmonumenten.cloud.intracto.com
    #   User staging-redactie
    #   IdentityFile ~/.ssh/id_ed25519

    Host coolify
      HostName 23.88.117.45
      User root
      IdentityFile ~/.ssh/coolify

    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/github

    Host gitlab.com
      HostName gitlab.com
      User bgit
      IdentityFile ~/.ssh/gitlab

    Host work-gitlab
      HostName gitlab.com
      User bgit
      IdentityFile ~/.ssh/gitlab_work

    Host bitbucket.org
      HostName bitbucket.org
      User git
      IdentityFile ~/.ssh/bitbucket

    Host nixos-server
      HostName 82.174.152.170
      User koenbenne
      IdentityFile ~/.ssh/nixos

    Host *.platform.sh
      Include /home/koenbenne/.platformsh/ssh/*.config
    Host *

    # BEGIN: Platform.sh certificate configuration
    Host *.platform.sh
      Include /Users/koenbenne/.platformsh/ssh/*.config
    Host *
    # END: Platform.sh certificate configuration


  '';
}
