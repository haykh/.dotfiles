{ ... }:

rec {
  user = "hayk";
  home = "/home/${user}";
  dotfiles = "${home}/.dotfiles";
  git = {
    username = "haykh";
    email = "haykh.astro@gmail.com";
  };
  shell_aliases = {
    vi = "nvim";
    vim = "nvim";
    ff = "fastfetch -l linux";
    nixbuild = "rm -f ~/.gtkrc-2.0.bak && rm -f ~/.config/mimeapps.list.bak && sudo nixos-rebuild switch --flake ${dotfiles}/nixos#$(hostname)";
    nixupd = "nix flake update --flake ${dotfiles}/nixos";
    flakecfg = "$EDITOR ${dotfiles}/nixos/flake.nix";
    nixcfg = "$EDITOR ${dotfiles}/nixos/";
    cat = "bat -pp --theme=TwoDark";
    ll = "ls --long --header --time-style=long-iso";
    lt = "ls --tree --level 2 --icons=always --color";
    ld = "ls --long --header --time-style=long-iso --total-size";
    rclone-reload = "systemctl --user restart mount-drives.service";
    code = "GTK_THEME='${gtktheme.main.env}' code --password-store=basic --profile 'hayk'";
    ofd = "dolphin --new-window \"$@\" 1>/dev/null 2>/dev/null & disown";
  };
  shell_functions = [
    ''
      function icat() {
        if [[ $TERM =~ 'ghostty' ]]; then 
          chafa -f kitty "$1"
        else 
          chafa -f iterm "$1"
        fi
      }
    ''
  ];
  gtktheme = {
    accent = "#7295F6";
    main = {
      pkg = "fluent-gtk-theme";
      interface = "Fluent-Dark";
      env = "Fluent:dark";
    };
    icon = {
      pkg = "fluent-icon-theme";
      interface = "Fluent-dark";
    };
    cursor = {
      pkg = "capitaine-cursors-themed";
      interface = "Capitaine Cursors";
    };
    wallpaper = "${dotfiles}/wallpapers/blueish-sunrise.jpg";
  };
  kdetheme = {
    plasmaTheme = "Fluent-round-dark";
    iconTheme = "Fluent-dark";
    cursorTheme = "Capitaine Cursors";
    kdedecoration2 = "__aurorae__svg__Fluent-round-dark";
  };
  bindings = {
    terminal = {
      binding = "<Super>t";
      action = "ghostty";
    };
    browser = {
      binding = "<Super>f";
      action = "zen";
    };
    nautilus = {
      binding = "<Super>e";
      action = "nautilus";
    };
    rofi-icons = {
      binding = "<Control><Super>i";
      action = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
    };
    calc = {
      binding = "<Control><Super>c";
      action = "${home}/.local/bin/crifo > /dev/null 2> &1";
    };
    refs = {
      binding = "<Control><Super>a";
      action = "${home}/.local/bin/llyfr ${home}/Documents/Literature/refs.bib ${home}/Documents/Literature > /dev/null 2> &1";
    };
    rofi-moji = {
      binding = "<Control><Super>j";
      action = "${dotfiles}/.config/rofi/apps/launch --emojis > /dev/null 2> &1";
    };
    rofi-drun = {
      binding = "<Control><Super>r";
      action = "${dotfiles}/.config/rofi/apps/launch --drun > /dev/null 2> &1";
    };
    largersize = {
      binding = "<Super>equal";
      action = "${dotfiles}/scripts/actions.sh --enlarge";
    };
    closewindow = {
      binding = "<Super>q";
      action = "${dotfiles}/scripts/actions.sh --close";
    };
    pickcolor = {
      binding = "<Control>Print";
      action = "${dotfiles}/scripts/actions.sh --pick-color";
    };
    open-slack = {
      binding = "<Super>s";
      action = "${dotfiles}/scripts/actions.sh --open slack";
    };
    open-email = {
      binding = "<Super>k";
      action = "${dotfiles}/scripts/actions.sh --open email";
    };
    screenshot-select = {
      binding = "Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot select";
    };
    screenshot-full = {
      binding = "<Control>Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot full";
    };
    screenshot-gui = {
      binding = "<Alt>Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot gui";
    };
  };
}
