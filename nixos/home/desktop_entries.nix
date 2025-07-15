{ pkgs, cfg, ... }:

{

  kdecolorpick = {
    ".local/share/applications/kdecolorpick.desktop".text = ''
      [Desktop Entry]
      Exec=${cfg.home}/.local/bin/wl-color-picker
      Name=wl-color-picker
      Icon=color
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  kdecolorchoose = {
    ".local/share/applications/kdecolorchoose.desktop".text = ''
      [Desktop Entry]
      Exec=${cfg.home}/.local/bin/wl-color-chooser
      Name=wl-color-chooser
      Icon=color
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  llyfr = {
    ".local/share/applications/llyfr.desktop".text = ''
      [Desktop Entry]
      Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb ${cfg.home}/.local/bin/llyfr ~/Documents/Literature/refs.bib
      Name=llyfr
      Icon=applications-education-symbolic
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  crifo = {
    ".local/share/applications/crifo.desktop".text = ''
      [Desktop Entry]
      Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb ${cfg.home}/.local/bin/crifo
      Name=crifo
      Icon=folder-calculate
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  onlyoffice = {
    ".local/share/applications/onlyoffice-desktopeditors.desktop".text = ''
      [Desktop Entry]
      Name=ONLYOFFICE Desktop Editors
      GenericName=Document Editor
      Exec=env GTK_THEME="${cfg.gtktheme.main.env}" onlyoffice-desktopeditors %U
      Icon=onlyoffice-desktopeditors
      Comment=Edit office documents
      Categories=Office;WordProcessor;Spreadsheet;Presentation;
      Terminal=false
    '';
  };

  chromium = {
    ".local/share/applications/chromium-browser.desktop".text = ''
      [Desktop Entry]
      Name=Chromium
      GenericName=Web Browser
      Exec=env GTK_THEME="${cfg.gtktheme.main.env}" chromium --password-store=basic %U
      Icon=chromium
      Comment=Access the Internet
      Categories=Network;WebBrowser;
      Terminal=false
    '';
  };

  slack = {
    ".local/share/applications/slack.desktop".text = ''
      [Desktop Entry]
      Name=Slack
      GenericName=Slack Client for Linux
      Exec=env GTK_THEME="${cfg.gtktheme.main.env}" slack -s %U
      Icon=slack
      Comment=Slack Desktop
      Categories=GNOME;GTK;Network;InstantMessaging;
      Terminal=false
    '';
  };

  vscode = {
    ".local/share/applications/code.desktop".text = ''
      [Desktop Entry]
      Name=Visual Studio Code
      GenericName=Text Editor
      Exec=env GTK_THEME="${cfg.gtktheme.main.env}" code --password-store=basic --profile "hayk" %F
      Icon=vscode
      Comment=Code Editing. Redefined.
      Categories=Utility;TextEditor;Development;IDE;
      Terminal=false
    '';
  };

  thorium = {
    ".local/share/applications/thorium-browser.desktop".text = ''
      [Desktop Entry]
      Name=Thorium Browser
      GenericName=Web Browser
      Exec=env GTK_THEME="${cfg.gtktheme.main.env}" thorium --password-store=basic --ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-features=TouchpadOverscrollHistoryNavigation --enable-pinch %U
      Icon=thorium-browser
      Comment=Access the Internet
      Categories=Network;WebBrowser;
      Terminal=false
    '';
  };

  unity = {
    ".local/share/applications/unityhub.desktop".text = ''
      [Desktop Entry]
      Name=Unity Hub
      Exec=env GDK_SCALE=2 GDK_DPI_SCALE=0.5 ${pkgs.unityhub}/bin/unityhub %U
      TryExec=${pkgs.unityhub}/bin/unityhub
      Terminal=false
      Type=Application
      Icon=unityhub
      StartupWMClass=unityhub
      Comment=The Official Unity Hub
      Categories=Development;
      MimeType=x-scheme-handler/unityhub;
    '';
  };

}
