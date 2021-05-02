set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/bundle/plugins/')
Plugin 'VundleVim/Vundle.vim'
" git diff:
Plugin 'airblade/vim-gitgutter'
Plugin 'nathanaelkane/vim-indent-guides'
" for commenting with \ + C + Spacebar:
Plugin 'preservim/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'cespare/vim-toml'
Plugin 'glepnir/oceanic-material'
call vundle#end()
filetype plugin indent on

" powerline
let g:airline_powerline_fonts = 1
" colorscheme
let g:airline_theme='kolor'
colo oceanic_material
let g:gruvbox_contrast_light = 'hard'
set background=dark

" fix python indentation
aug python
  " ftype/python.vim overwrites this
  au FileType python setlocal ts=2 sts=2 sw=2 expandtab
aug end

" indentation guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2

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

