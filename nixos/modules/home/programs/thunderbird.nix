{
  config,
  lib,
  cfg,
  ...
}:

let
  this = config.my.programs.thunderbird;
in
{

  options.my.programs.thunderbird.enable = lib.mkEnableOption "thunderbird";

  config = lib.mkIf this.enable {

    programs.thunderbird = {
      enable = true;

      settings = {
        "mail.shell.checkDefaultClient" = false;
        "mailnews.mark_message_read.auto" = false;
        "privacy.donottrackheader.enabled" = true;
        "datareporting.healthreport.uploadEnabled" = false;
      };
      profiles.${cfg.user}.isDefault = true;
    };

  };

}
