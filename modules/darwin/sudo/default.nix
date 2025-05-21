{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc."sudoers.d/custom".text = ''
    Defaults timestamp_timeout=300
    Defaults env_keep += "TERMINFO"
  '';
  security.pam.services.sudo_local.touchIdAuth = true;
}
