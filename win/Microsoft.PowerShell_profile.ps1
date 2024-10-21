Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\.config\starship.toml"

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# aliases
Set-Alias -Name vi -Value nvim
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}
$ENV:Path += ';C:\Users\hayk\software\eza\'
function eza {
  eza.exe --color=always --icons=always -a $args
}
Set-Alias ls eza
function Get-PathOnly {
  return (Get-Location).Path
}
Set-Alias pwd Get-PathOnly -Scope Script

# conda
$env:Path += ';C:\Users\hayk\miniconda3\Scripts'
