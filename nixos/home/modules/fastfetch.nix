{ ... }:

{

  settings = {
    display = {
      constants = [
        "┌"
        "└"
        "│"
      ];
      separator = "";
      key.width = 15;
    };

    logo.padding.top = 2;

    modules = [
      {
        type = "custom";
        format = " {$1}";
        outputColor = "blue";
      }
      {
        type = "os";
        keyIcon = "󱄅";
        key = "S{$3} {icon} os";
        keyColor = "blue";
      }
      {
        type = "kernel";
        key = "Y{$3} {icon} kernel";
        keyColor = "blue";
      }
      {
        type = "packages";
        key = "S{$3} {icon} pkgs";
        keyColor = "blue";
      }
      {
        type = "bios";
        key = "T{$3} {icon} bios";
        keyColor = "blue";
      }
      {
        type = "command";
        keyIcon = "";
        key = "M{$3} {icon} params";
        keyColor = "blue";
        text = "cat /proc/cmdline | awk '{for(i=1;i<=NF;i++) if($i !~ /^init=/ && $i !~ /^initrd=/) printf \"%s \", $i}'";
        format = "{~0}";
      }
      {
        type = "custom";
        format = " {$2}";
        outputColor = "blue";
      }
      {
        type = "custom";
        format = " {$1}";
        outputColor = "yellow";
      }
      {
        type = "cpu";
        key = "H{$3} {icon} cpu";
        keyColor = "yellow";
      }
      {
        type = "memory";
        key = "A{$3} {icon} ram";
        keyColor = "yellow";
      }
      {
        type = "swap";
        key = "R{$3} {icon} swap";
        keyColor = "yellow";
      }
      {
        type = "battery";
        key = "D{$3} {icon} bat";
        keyColor = "yellow";
      }
      {
        type = "disk";
        key = "W{$3} {icon} /";
        keyColor = "yellow";
        folders = "/";
      }
      {
        type = "disk";
        key = "R{$3} {icon} /home";
        keyColor = "yellow";
        folders = "/home";
      }
      {
        type = "custom";
        format = " {$2}";
        outputColor = "yellow";
      }
      {
        type = "custom";
        format = " {$1}";
        outputColor = "red";
      }
      {
        type = "gpu";
        key = "D{$3} {icon} gpu";
        keyColor = "red";
        hideType = "discrete";
      }
      {
        type = "gpu";
        key = "I{$3} {icon} gpu";
        keyColor = "red";
        hideType = "integrated";
      }
      {
        type = "display";
        key = "S{$3} {icon} res";
        keyColor = "red";
        compactType = "original-with-refresh-rate";
      }
      {
        type = "de";
        key = "P{$3} {icon} de";
        keyColor = "red";
      }
      {
        type = "wm";
        key = "L{$3} {icon} wm";
        keyColor = "red";
      }
      {
        type = "opengl";
        key = "A{$3} {icon} opengl";
        keyColor = "red";
      }
      {
        type = "vulkan";
        key = "Y{$3} {icon} vulkan";
        keyColor = "red";
      }
      {
        type = "custom";
        format = " {$2}";
        outputColor = "red";
      }
      {
        type = "custom";
        format = " {$1}";
        outputColor = "green";
      }
      {
        type = "terminal";
        key = "D{$3} {icon} term";
        keyColor = "green";
      }
      {
        type = "editor";
        key = "E{$3} {icon} editor";
        keyColor = "green";
      }
      {
        type = "command";
        keyIcon = "";
        key = "V{$3} {icon} nodejs";
        keyColor = "green";
        text = "node --version";
        format = "{~1}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "P{$3} {icon} npm";
        keyColor = "green";
        text = "npm -v";
        format = "{~0}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "K{$3} {icon} go";
        keyColor = "green";
        text = "go version | cut -d' ' -f3";
        format = "{~2}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "G{$3} {icon} gcc";
        keyColor = "green";
        text = "gcc --version | head -n 1 | cut -d' ' -f3";
        format = "{~0}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "S{$3} {icon} py";
        keyColor = "green";
        text = "python3 --version | cut -d' ' -f2";
        format = "{~0}";
      }
      {
        type = "custom";
        format = " {$2}";
        outputColor = "green";
      }
      "break"
      "colors"
    ];
  };

}
