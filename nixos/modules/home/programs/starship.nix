{
  config,
  lib,
  pkgs,
  ...
}:

let
  this = config.my.programs.starship;
in
{

  options.my.programs.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf this.enable {

    programs.starship = {
      enable = true;

  settings = {
    format = pkgs.lib.concatStrings [
      "$directory"
      "$git_branch"
      "$git_state"
      "$git_status"
      "$python"
      "$conda"
      "$fill"
      "$spack"
      "$nix_shell"
      "$cmd_duration"
      "$username"
      "$hostname"
      "$os"
      "$line_break"
      "$character"
    ];
    directory = {
      style = "blue";
      truncation_length = 4;
      truncate_to_repo = false;
      truncation_symbol = "…/";
      read_only = "";
    };
    fill = {
      symbol = " ";
    };
    character = {
      success_symbol = "[󰇂 ](green)";
      error_symbol = "[󰇂 ](red)";
      vimcmd_symbol = "[❮](green)";
    };

    git_branch = {
      format = "[$branch]($style) ";
      style = "bright-green";
    };

    git_status = {
      format = "[ ( $conflicted)( $stashed)( $deleted)( $renamed)( $modified)( $typechanged)( $staged)( $untracked)]($style) ";
      style = "bright-yellow";
      stashed = "≡";
      ahead = "⇡\${count}";
      diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      behind = "⇣\${count}";
      untracked = "?\${count}";
      modified = "!\${count}";
    };

    git_state = {
      format = "\([$state( $progress_current/$progress_total)]($style)\) ";
      style = "bright-black";
    };

    cmd_duration = {
      format = "[$duration]($style) ";
      style = "yellow";
    };

    conda = {
      format = "[$symbol $environment]($style) ";
      symbol = "󱔎";
      style = "dimmed green";
    };

    python = {
      format = "[($symbol $virtualenv)]($style) ";
      symbol = "";
      style = "dimmed green";
    };

    os = {
      format = "[$symbol]($style) ";
      style = "bold blue";
      disabled = false;
      symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };
    };

    username = {
      show_always = true;
      disabled = false;
      style_root = "red";
      style_user = "purple";
      format = "[$user]($style) ";
    };

    hostname = {
      format = "[($ssh_symbol)$hostname]($style) ";
      disabled = false;
      ssh_only = false;
      ssh_symbol = " ";
      style = "white";
    };

    time = {
      disabled = false;
      format = "[\[ $time \]]($style) ";
      time_format = "%a %-e %h %-I:%M%P";
      utc_time_offset = "-4";
      use_12hr = true;
      style = "dimmed white";
    };

    nix_shell = {
      symbol = "󰜗 ";
      format = "[$symbol\\($name\\)]($style) ";
    };

    spack = {
      symbol = "󰙲 ";
      style = "dimmed yellow";
      format = "[$symbol$environment]($style) ";
    };

    battery = {
      full_symbol = "󰁹 ";
      discharging_symbol = "󰁹 ";
      charging_symbol = "󰂅 ";
      unknown_symbol = "󰂅 ";
      display = [
        {
          threshold = 10;
          discharging_symbol = "󰁻 ";
          charging_symbol = "󰢜 ";
          style = "bold red";
        }
        {
          threshold = 30;
          discharging_symbol = "󰁼 ";
          charging_symbol = "󰢝 ";
          style = "bold yellow";
        }
        {
          threshold = 50;
          discharging_symbol = "󰁽 ";
          charging_symbol = "󰢝 ";
          style = "bold yellow";
        }
        {
          threshold = 75;
          discharging_symbol = "󰂁 ";
          charging_symbol = "󰢞 ";
          style = "bold green";
        }
        {
          threshold = 100;
          discharging_symbol = "󰁹 ";
          charging_symbol = "󰂅 ";
          style = "bold green";
        }
      ];
    };
  };

    };

  };

}
