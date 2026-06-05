{ pkgs, cfg, ... }:

let
  home = cfg.home;
  localDir = "${home}/Literature";
  remote = "GDrive:Literature";
in
{

  Unit = {
    Description = "Bidirectional sync of ${remote} <-> ${localDir}";
    After = [ "network-online.target" ];
    StartLimitIntervalSec = 600;
    StartLimitBurst = 20;
  };
  Service = {
    Type = "simple";
    Restart = "on-failure";
    RestartSec = 30;
    ExecStart = "${pkgs.writeShellScript "literatureBisync" ''
      sentinel="${home}/.cache/rclone/literature-bisync-initialized"
      /usr/bin/env mkdir -p "$(/usr/bin/env dirname "$sentinel")" ${localDir}
      if [ ! -e "$sentinel" ]; then
        ${pkgs.rclone}/bin/rclone bisync \
          --config=${home}/.config/rclone/rclone.conf \
          ${remote} ${localDir} \
          --resync --create-empty-src-dirs \
        && /usr/bin/env touch "$sentinel"
      fi
      while true; do
        ${pkgs.rclone}/bin/rclone bisync \
          --config=${home}/.config/rclone/rclone.conf \
          ${remote} ${localDir} \
          --create-empty-src-dirs \
          --conflict-resolve newer \
          --resilient --recover \
        || true
        /usr/bin/env sleep 300
      done
    ''}";
  };
  Install.WantedBy = [ "default.target" ];

}
