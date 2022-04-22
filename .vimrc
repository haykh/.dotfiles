set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin('~/.vim/bundle/plugins/')
Plugin 'VundleVim/Vundle.vim'

" git diff:
Plugin 'airblade/vim-gitgutter'

" looks
Plugin 'glepnir/oceanic-material'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'thaerkh/vim-indentguides'

" extension specific highlighting & plugins
Plugin 'cespare/vim-toml'
Plugin 'tikhomirov/vim-glsl'
Plugin 'chrisbra/Colorizer'
Plugin 'lervag/vimtex'
Plugin 'digitaltoad/vim-pug'

" shortcuts 
Plugin 'junegunn/vim-easy-align'
Plugin 'preservim/nerdcommenter'

" nvim specific
Plugin 'voldikss/vim-floaterm'

call vundle#end()
filetype plugin indent on

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme='kolor'

" vanilla vim flags
set viminfo='50,<1000,s100,h
set background=dark
colo oceanic_material
syntax on
hi Error NONE
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
set hlsearch
hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi Directory ctermfg=Blue
set cursorline
set noswapfile
set ignorecase
set incsearch
inoremap jk <ESC>
" save cursor position after insert mode
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

set viminfo='20,<1000,s1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
set backspace=indent,eol,start

" customize vertical separator
set fillchars+=vert:│
hi VertSplit cterm=NONE ctermfg=238 ctermbg=NONE
" customize color highlightings
hi EndOfBuffer ctermfg=238
hi SignColumn ctermbg=NONE

" indentation guides
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
let g:indentguides_toggleListMode = 0

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25

" minimap
let g:minimap_auto_start = 1
let g:minimap_highlight_range = 1
let g:minimap_base_highlight = 'NonText' 
let g:minimap_highlight = 'MoreMsg' 
let g:minimap_width = 15

" for background to be transparent to terminal
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

" vimtex
let g:vimtex_quickfix_mode = 0
let g:vimtex_syntax_conceal_disable = 1

" alignment
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" experimental
"tnoremap <M-h> <C-\><C-n><C-w>h
"tnoremap <M-j> <C-\><C-n><C-w>j
"tnoremap <M-k> <C-\><C-n><C-w>k
"tnoremap <M-l> <C-\><C-n><C-w>l
tnoremap <Leader>ff <C-\><C-n><C-w>w
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'
let g:floaterm_keymap_hide = '<Leader>fh'
let g:floaterm_keymap_show = '<Leader>fs'
let g:floaterm_position = 'topright'
let g:floaterm_height = 0.35
let g:floaterm_width = 0.45
"let g:floaterm_wintype = 'split'
