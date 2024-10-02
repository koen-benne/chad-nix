{
  config,
  lib,
  pkgs,
  ...
}: {
  home.file.".ssh/config".text = ''


    Host backend.acc.natuurmonumenten.cloud.intracto.com
      HostName backend.acc.natuurmonumenten.cloud.intracto.com
      User staging-redactie
      IdentityFile ~/.ssh/id_ed25519

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

    Host bitbucket.org
      HostName bitbucket.org
      User git
      IdentityFile ~/.ssh/bitbucket

    Host nixos
      HostName 77.169.201.160
      User koenbenne
      IdentityFile ~/.ssh/nixos

    Host *.platform.sh
      Include /home/koenbenne/.platformsh/ssh/*.config
    Host *


  '';
}
