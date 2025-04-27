{ cfg, ... }:

{
  entries ? [ ],
}:

let
  desktopfiles = {
    onlyoffice = {
      xdg.desktopEntries.onlyoffice-desktopeditors = {
        name = "ONLYOFFICE Desktop Editors";
        genericName = "Document Editor";
        exec = "env GTK_THEME=\"${cfg.gtktheme.main.env}\" onlyoffice-desktopeditors %U";
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
    };

    chromium = {
      xdg.desktopEntries.chromium-browser = {
        name = "Chromium";
        genericName = "Web Browser";
        exec = "env GTK_THEME=\"${cfg.gtktheme.main.env}\" chromium --password-store=basic %U";
        icon = "chromium";
        comment = "Access the Internet";
        categories = [
          "Network"
          "WebBrowser"
        ];
        terminal = false;
      };
    };

    slack = {
      xdg.desktopEntries.slack = {
        name = "Slack";
        genericName = "Slack Client for Linux";
        exec = "env GTK_THEME=\"${cfg.gtktheme.main.env}\" slack -s %U";
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
    };

    vscode = {
      xdg.desktopEntries.code = {
        name = "Visual Studio Code";
        genericName = "Text Editor";
        exec = "env GTK_THEME=\"${cfg.gtktheme.main.env}\" code --profile \"hayk\" %F";
        icon = "vscode";
        comment = "Code Editing. Redefined.";
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
      };
    };

    mimeapps = {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
          "x-scheme-handler/slack" = "slack.desktop";
          "image/gif" = "oculante.desktop";
          "image/png" = "oculante.desktop";
          "image/jpeg" = "oculante.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";
        };

        associations.added = {
          "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
          "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
          "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
          "image/gif" = "oculante.desktop";
          "image/png" = "oculante.desktop";
          "image/jpeg" = "oculante.desktop";
          "x-scheme-handler/mailto" = "thunderbird.desktop";
        };
      };
    };

  };
in
builtins.foldl' (acc: name: acc // desktopfiles.${name}) { } (
  builtins.filter (name: builtins.hasAttr name desktopfiles) entries
)
