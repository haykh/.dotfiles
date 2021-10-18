# zsh functions
fpath+=~/.dotfiles/.zsh_functions
autoload -U $fpath[-1]/*(.:t)
