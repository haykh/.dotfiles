{ themeEnv, ... }:

{
  xdg.desktopEntries.onlyoffice-desktopeditors = {
    name = "ONLYOFFICE Desktop Editors";
    genericName = "Document Editor";
    exec = "env GTK_THEME=\"${themeEnv}\" onlyoffice-desktopeditors %U";
    icon = "onlyoffice-desktopeditors";
    comment = "Edit office documents";
    categories = [
      "Office"
      "WordProcessor"
      "Spreadsheet"
      "Presentation"
    ];
    terminal = false;
  };

  xdg.desktopEntries.chromium-browser = {
    name = "Chromium";
    genericName = "Web Browser";
    exec = "env GTK_THEME=\"${themeEnv}\" chromium --password-store=basic %U";
    icon = "chromium";
    comment = "Access the Internet";
    categories = [
      "Network"
      "WebBrowser"
    ];
    terminal = false;
  };

  xdg.desktopEntries.slack = {
    name = "Slack";
    genericName = "Slack Client for Linux";
    exec = "env GTK_THEME=\"${themeEnv}\" slack -s %U";
    icon = "slack";
    comment = "Slack Desktop";
    categories = [
      "GNOME"
      "GTK"
      "Network"
      "InstantMessaging"
    ];
    terminal = false;
  };
}
