{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    # extensions = with pkgs.vscode-extensions; [
    #   ms-vscode-remote.remote-ssh
    #   github.github-vscode-theme
    #   xaver.clang-format
    #   ms-vscode.cmake-tools
    #   github.copilot
    #   github.copilot-chat
    #   ms-python.black-formatter
    #   ms-python.python
    #   ms-python.pylint
    #   ms-toolsai.jupyter
    #   ms-vscode.cpptools-extension-pack
    #   naumovs.color-highlight
    #   tamasfe.even-better-toml
    # ];
  };
}
