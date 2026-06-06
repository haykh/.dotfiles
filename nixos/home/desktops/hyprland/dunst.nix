{ cfg, ... }:

{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Noto Sans 11";
        frame_color = cfg.gtktheme.accent;
        separator_color = "frame";
        corner_radius = 8;
        offset = "12x12";
        origin = "top-right";
        width = 360;
        padding = 12;
        horizontal_padding = 16;
        frame_width = 1;
        markup = "full";
        format = "<b>%s</b>\\n%b";
      };

      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 4;
      };
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 6;
      };
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };

}
