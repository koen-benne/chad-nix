{ config, lib, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  accounts.email = {
    accounts.personal = {
      address = config.my.email;
      imap.host = "imap.gmail.com";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      realName = config.my.name;
      # signature = {
      #   text = ''
      #     Met vriendelijke groet,
      #     Koen Benne
      #   '';
      #   showSignature = "append";
      # };
      passwordCommand = "mail-password";
      smtp = {
        host = "smtp.gmail.com";
      };
      userName = config.my.email;
    };
  };
}

