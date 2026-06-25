{ cfg, ... }:

{

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = true;
        hide_cursor = true;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = cfg.gtktheme.wallpaper;
          blur_passes = 3;
          blur_size = 8;
          contrast = 0.9;
          brightness = 0.25;
          vibrancy = 0.5;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "260, 50";
          position = "0, -120";
          halign = "center";
          valign = "center";
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 2;
          outer_color = "rgb(156, 185, 221)";
          inner_color = "rgb(19, 29, 43)";
          font_color = "rgb(156, 185, 221)";
          check_color = "rgb(156, 185, 221)";
          fail_color = "rgb(237, 41, 57)";
          font_family = "MonaspiceKr Nerd Font";
          placeholder_text = ''<i><span foreground="##9cb9dd">passwd</span></i>'';
          hide_input = false;
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +'%-I:%M%P'";
          color = "rgb(180, 195, 221, 0.95)";
          font_size = 120;
          font_family = "MonaspiceKr Nerd Font";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgb(180, 195, 221, 0.95)";
          font_size = 25;
          font_family = "MonaspiceKr Nerd Font";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

}
