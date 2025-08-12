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
        format = "{$1}";
        outputColor = "blue";
      }
      {
        type = "os";
        keyIcon = "󱄅";
        key = "{$3} {icon} os";
        keyColor = "blue";
      }
      {
        type = "kernel";
        key = "{$3} {icon} kernel";
        keyColor = "blue";
      }
      {
        type = "packages";
        key = "{$3} {icon} pkgs";
        keyColor = "blue";
      }
      {
        type = "bios";
        key = "{$3} {icon} bios";
        keyColor = "blue";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} params";
        keyColor = "blue";
        text = "cat /proc/cmdline | awk '{for(i=1;i<=NF;i++) if($i !~ /^init=/ && $i !~ /^initrd=/) printf \"%s \", $i}'";
        format = "{~0}";
      }
      {
        type = "custom";
        format = "{$2}";
        outputColor = "blue";
      }
      {
        type = "custom";
        format = "{$1}";
        outputColor = "yellow";
      }
      {
        type = "cpu";
        key = "{$3} {icon} cpu";
        keyColor = "yellow";
      }
      {
        type = "memory";
        key = "{$3} {icon} ram";
        keyColor = "yellow";
      }
      {
        type = "swap";
        key = "{$3} {icon} swap";
        keyColor = "yellow";
      }
      {
        type = "battery";
        key = "{$3} {icon} bat";
        keyColor = "yellow";
      }
      {
        type = "disk";
        key = "{$3} {icon} /";
        keyColor = "yellow";
        folders = "/";
      }
      {
        type = "disk";
        key = "{$3} {icon} /home";
        keyColor = "yellow";
        folders = "/home";
      }
      {
        type = "custom";
        format = "{$2}";
        outputColor = "yellow";
      }
      {
        type = "custom";
        format = "{$1}";
        outputColor = "red";
      }
      {
        type = "gpu";
        key = "{$3} {icon} gpu";
        keyColor = "red";
        hideType = "discrete";
      }
      {
        type = "gpu";
        key = "{$3} {icon} gpu";
        keyColor = "red";
        hideType = "integrated";
      }
      {
        type = "display";
        key = "{$3} {icon} res";
        keyColor = "red";
        compactType = "original-with-refresh-rate";
      }
      {
        type = "de";
        key = "{$3} {icon} de";
        keyColor = "red";
      }
      {
        type = "wm";
        key = "{$3} {icon} wm";
        keyColor = "red";
      }
      {
        type = "opengl";
        key = "{$3} {icon} opengl";
        keyColor = "red";
      }
      {
        type = "vulkan";
        key = "{$3} {icon} vulkan";
        keyColor = "red";
      }
      {
        type = "custom";
        format = "{$2}";
        outputColor = "red";
      }
      {
        type = "custom";
        format = "{$1}";
        outputColor = "green";
      }
      {
        type = "terminal";
        key = "{$3} {icon} term";
        keyColor = "green";
      }
      {
        type = "editor";
        key = "{$3} {icon} editor";
        keyColor = "green";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} nodejs";
        keyColor = "green";
        text = "node --version";
        format = "{~1}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} npm";
        keyColor = "green";
        text = "npm -v";
        format = "{~0}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} go";
        keyColor = "green";
        text = "go version | cut -d' ' -f3";
        format = "{~2}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} gcc";
        keyColor = "green";
        text = "gcc --version | head -n 1 | cut -d' ' -f3";
        format = "{~0}";
      }
      {
        type = "command";
        keyIcon = "";
        key = "{$3} {icon} py";
        keyColor = "green";
        text = "python3 --version | cut -d' ' -f2";
        format = "{~0}";
      }
      {
        type = "custom";
        format = "{$2}";
        outputColor = "green";
      }
      "break"
      "colors"
    ];
  };

}
