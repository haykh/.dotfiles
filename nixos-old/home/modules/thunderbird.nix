{ cfg, ... }:

{

  settings = {
    "mail.shell.checkDefaultClient" = false;
    "mailnews.mark_message_read.auto" = false;
    "privacy.donottrackheader.enabled" = true;
    "datareporting.healthreport.uploadEnabled" = false;
  };
  profiles.${cfg.user}.isDefault = true;

}
