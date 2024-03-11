{ config, lib, pkgs, ... }:
{
  home.file.".ssh/config".text = ''



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



  '';
}
