{ ... }:

rec {
  user = "hayk";
  home = "/home/${user}";
  dotfiles = "${home}/.dotfiles";
  git = {
    username = "haykh";
    email = "haykh.astro@gmail.com";
  };
  envvars = {
    DOTFILES = "${dotfiles}";
    EDITOR = "nvim";
    NEWT_COLORS = "root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=white,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black";
    PROTON_PASS_KEY_PROVIDER = "fs";
  };
  shell_aliases = {
    vi = "nvim";
    vim = "nvim";
    ff = "fastfetch -l linux";
    nixbuild = "sudo nixos-rebuild switch --flake ${dotfiles}/nixos#$(hostname)";
    nixupd = "nix flake update --flake ${dotfiles}/nixos";
    nixcfg = "$EDITOR ${dotfiles}/nixos/";
    cat = "bat -pp --theme=TwoDark";
    ll = "ls --long --header --time-style=long-iso";
    lt = "ls --tree --level 2 --icons=always --color";
    ld = "ls --long --header --time-style=long-iso --total-size";
    ofd = "thunar \"$@\" 1>/dev/null 2>/dev/null & disown";
  };
  shell_functions = {
    icat = ''
      if [[ $TERM =~ 'ghostty' ]]; then 
        chafa -f kitty "$1"
      else 
        chafa -f iterm "$1"
      fi
    '';
    ppass = ''
      pass-cli item view "pass://accounts/$1/password" | tr -d "[:space:]" | wl-copy
    '';
  };
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
}
