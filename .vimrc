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
" auto align to character (experimental)
Plugin 'junegunn/vim-easy-align'
" tex syntax
Plugin 'lervag/vimtex'
call vundle#end()
filetype plugin indent on

" powerline
let g:airline_powerline_fonts = 1
" colorscheme
let g:airline_theme='kolor'
colo oceanic_material
let g:gruvbox_contrast_light = 'hard'
set background=dark

" vanilla vim flags
syntax on
hi Error NONE
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
set hlsearch
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
set cursorline
set noswapfile
set ignorecase
set incsearch
inoremap jk <ESC>

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
" fix python indentation
aug python
  " ftype/python.vim overwrites this
  au FileType python setlocal ts=2 sts=2 sw=2 expandtab
aug end
" indentation guides
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
let g:indentguides_toggleListMode = 0

" customize vertical separator
set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE

" for background to be transparent to terminal
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

let loaded_netrwPlugin = 1

" vimtex
let g:vimtex_quickfix_enabled = 0
let g:vimtex_syntax_conceal_default = 0

" experimental
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
