{ pkgs, config, ... }:

let
  home = config.home.homeDirectory;
in
{

  Unit = {
    Description = "Mount all remote drives";
    After = [ "network-online.target" ];
  };
  Service = {
    Type = "forking";
    ExecStartPre = "${pkgs.writeShellScript "rClonePre" ''
      remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
      for remote in $remotes; do
        name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
        /usr/bin/env mkdir -p ${home}/"$name"
      done
    ''}";
    ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
      remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
      for remote in $remotes; do
        name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
        ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount "$remote" "$name" &
      done
      ${pkgs.rclone}/bin/rclone sync GDrive:docs/Literature/ ${home}/Documents/Literature
    ''}";
    ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
      remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
      for remote in $remotes; do
        name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
        /usr/bin/env fusermount -u ${home}/"$name"
      done
    ''}";
  };
  Install.WantedBy = [ "default.target" ];

}
