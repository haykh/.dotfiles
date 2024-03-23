oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/onehalf.minimal.omp.json' | Invoke-Expression
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord

# aliases
Set-Alias -Name vi -Value nvim
function which($name) {
  Get-Command $name | Select-Object -ExpandProperty Definition
}
$env:Path += ';D:\Software\eza\'
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
