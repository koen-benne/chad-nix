{ config, lib, pkgs, ... }:

{
  programs.mbsync.enable = true;
  programs.lieer.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
  };

  accounts.email = {
    accounts.personal = {
      flavor = "gmail.com";
      address = config.my.email;
      imap.host = "imap.gmail.com";
      # mbsync = {
      #   enable = true;
      #   create = "maildir";
      # };
      lieer = {
        enable = true;
        sync.enable = true;
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
    # accounts.work = {
    #   flavor = "outlook.office365.com";
    #   address = config.my.workmail;
    #   imap.host = "outlook.office365.com";
    # };
  };
}

