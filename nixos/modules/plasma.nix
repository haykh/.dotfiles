{ pkgs, ... }:

{

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    elisa
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      kdePackages.xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };

  # Workaround for Plasma 6 / KWin Wayland bug where popup menus render with
  # opaque white backgrounds after resume from suspend. Restarting plasmashell
  # restores the proper transparency without ending the session.
  # Runs as a system service (user-level suspend.target isn't propagated by
  # default) and reaches into the user manager via XDG_RUNTIME_DIR.
  systemd.services.plasmashell-resume-fix = {
    description = "Restart plasmashell after resume to fix white menu backgrounds";
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "hayk";
      Environment = "XDG_RUNTIME_DIR=/run/user/1000";
      ExecStart = "${pkgs.systemd}/bin/systemctl --user restart plasma-plasmashell.service";
    };
  };

}
