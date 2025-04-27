{ cfg, ... }:

{

  config = {
    keep-open = true;
    autofit = "75%x85%";
    screenshot-directory = "${cfg.home}/Pictures/Screenshots";
  };
  bindings = {
    "]" = "seek 5 exact";
    "[" = "seek -5 exact";
    "RIGHT" = "frame-step";
    "LEFT" = "frame-back-step";
    "v" = "vf toggle hflip";
  };

}
