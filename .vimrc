set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/bundle/plugins/')
Plugin 'VundleVim/Vundle.vim'
" git diff:
Plugin 'airblade/vim-gitgutter'
Plugin 'thaerkh/vim-indentguides'
" for commenting with \ + C + Spacebar:
Plugin 'preservim/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'cespare/vim-toml'
Plugin 'glepnir/oceanic-material'
Plugin 'chrisbra/Colorizer'
Plugin 'junegunn/vim-easy-align'
call vundle#end()
filetype plugin indent on

" powerline
let g:airline_powerline_fonts = 1
" colorscheme
let g:airline_theme='kolor'
colo oceanic_material
let g:gruvbox_contrast_light = 'hard'
set background=dark

" colorizer
let g:colorizer_auto_filetype='css,html,yaml,toml'

" fix python indentation
aug python
  " ftype/python.vim overwrites this
  au FileType python setlocal ts=2 sts=2 sw=2 expandtab
aug end

" indentation guides
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
let g:indentguides_toggleListMode = 0

" vanilla vim flags
syntax on
hi Error NONE
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
" customize vertical separator
set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE

" for background to be transparent to terminal
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

let loaded_netrwPlugin = 1

" experimental
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

