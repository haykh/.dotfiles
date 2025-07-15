{ cfg, ... }:

{

  workspace = {
    lookAndFeel = "org.kde.breezedark.desktop";
    cursor = {
      theme = cfg.kdetheme.cursorTheme;
      size = 32;
    };
    iconTheme = cfg.kdetheme.iconTheme;
    wallpaper = "${cfg.dotfiles}/wallpapers/blueish-sunrise.jpg";
  };

  fonts = {
    general = {
      family = "Noto Sans";
      pointSize = 12;
    };
  };

  window-rules = [
    {
      description = "Thunar";
      match = {
        window-class = {
          value = "thunar";
          type = "substring";
        };
        window-types = [ "normal" ];
      };
      apply = {
        noborder = {
          value = true;
          apply = "force";
        };
      };
    }
    {
      description = "Thorium";
      match = {
        window-class = {
          value = "Thorium-browser";
          type = "substring";
        };
      };
      apply = {
        noborder = {
          value = true;
          apply = "initially";
        };
      };
    }
    {
      description = "Unityhub";
      match = {
        window-class = {
          value = "Unity";
          type = "substring";
        };
      };
      apply = {
        noborder = {
          value = true;
          apply = "initially";
        };
      };
    }
    {
      description = "Godot";
      match = {
        window-class = {
          value = "Godot";
          type = "substring";
        };
      };
      apply = {
        noborder = {
          value = true;
          apply = "force";
        };
      };
    }
  ];

  kwin = {
    edgeBarrier = 0;
    cornerBarrier = false;
  };

  shortcuts = {
    kwin = {
      "Window Maximize" = "Meta+Up";
      "Window Minimize" = "Meta+M";
      "Window On All Desktops" = "Meta+Ctrl+T";
      "Activate Window Demanding Attention" = "";
      "Window Close" = "Meta+Q";
    };
    # "services/slack.desktop"."_launch" = "Meta+S";
    "services/thunar.desktop"."_launch" = "Meta+E";
    "services/zen.desktop"."_launch" = "Meta+F";
    "services/com.mitchellh.ghostty.desktop"."_launch" = "Meta+T";
    "services/net.local.kdecolorpick.desktop"."_launch" = "Alt+Print";
    "services/net.local.kdecolorchoose.desktop"."_launch" = "Alt+Shift+Print";
    "services/net.local.crifo.desktop"."_launch" = "Meta+Ctrl+C";
    "services/net.local.llyfr.desktop"."_launch" = "Meta+Ctrl+A";
    "services/org.kde.krunner.desktop"."_launch" = [
      "Search"
      "Ctrl+Alt+Space"
    ];
    "services/org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Print";
  };
  configFile = {
    plasma-localerc.Formats.LANG = "en_US.UTF-8";
    kcminputrc = {
      Mouse = {
        cursorTheme = cfg.kdetheme.cursorTheme;
        X11LibInputXAccelProfileFlat = true;
      };
      "Libinput/2362/628/PIXA3854:00 093A:0274 Touchpad" = {
        ClickMethod = 2;
        NaturalScroll = true;
      };
    };
    kdeglobals = {
      General = {
        TerminalApplication = "ghostty";
        TerminalService = "com.mitchellh.ghostty.desktop";

        AccentColor = "90,122,193";
        XftHintStyle = "hintslight";
        XftSubPixel = "none";
        accentColorFromWallpaper = true;
        fixed = "MonaspiceKr Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      };
      WM = {
        activeBackground = "40,40,40";
        activeBlend = "40,40,40";
        activeForeground = "223,223,223";
        inactiveBackground = "46,46,46";
        inactiveBlend = "46,46,46";
        inactiveForeground = "105,105,105";
      };
      KDE.SingleClick = false;
    };
    kwinrc = {
      Plugins.blurEnabled = true;
      Effect-blur.BlurStrength = 7;

      Plugins.dynamic_workspacesEnabled = true;
      Script-dynamic_workspaces."keepEmptyMiddleDesktops" = true;

      Plugins.poloniumEnabled = false;

      Desktops.Number = {
        value = 2;
      };

      "Effect-overview"."BorderActivate" = 9;

      Xwayland.Scale = 1.25;
      "org.kde.kdecoration2".ButtonsOnLeft = "SF";
      "org.kde.kdecoration2".ButtonsOnRight = "HAIX";
      "org.kde.kdecoration2".theme = cfg.kdetheme.kdedecoration2;
    };
    kxkbrc = {
      Layout = {
        DisplayNames = ",";
        LayoutList = "us,ru";
        Use = true;
        VariantList = ",phonetic";
      };
    };
    kscreenlockerrc = {
      Greeter.WallpaperPlugin = "org.kde.potd";
      "Greeter/Wallpaper/org.kde.potd/General"."Provider" = "bing";
    };
    plasmarc = {
      Theme.name = cfg.kdetheme.plasmaTheme;
    };
    plasmanotifyrc = {
      "Applications/thunderbird".Seen = true;
    };
  };

}
