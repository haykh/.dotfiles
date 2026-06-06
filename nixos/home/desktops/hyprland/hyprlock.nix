{ cfg, ... }:

{

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = cfg.gtktheme.wallpaper;
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "260, 50";
          position = "0, -120";
          halign = "center";
          valign = "center";
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 2;
          outer_color = "rgb(9cb9dd)";
          inner_color = "rgb(20, 24, 32)";
          font_color = "rgb(223, 223, 223)";
          placeholder_text = ''<span foreground="##aaaaaa">password</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +'%-I:%M%P'";
          font_size = 96;
          font_family = "Noto Sans";
          color = "rgb(223, 223, 223)";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

}
