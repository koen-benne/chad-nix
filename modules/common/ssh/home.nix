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

    Host ssh.dev.azure.com
      HostName ssh.dev.azure.com
      User git
      IdentityFile ~/.ssh/azure

    Host nixos-server
      HostName 82.174.152.170
      User koenbenne
      IdentityFile ~/.ssh/nixos

    # BEGIN: Upsun certificate configuration
    Host *.platform.sh *.upsun.com
      Include /Users/koenbenne/.upsun-cli/ssh/*.config
    Host *
    # END: Upsun certificate configuration


  '';
}
