call plug#begin()
" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" filesystem
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" looks
Plug 'projekt0n/github-nvim-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" language specific
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'
Plug 'digitaltoad/vim-pug'
Plug 'lervag/vimtex'

" auto-completion
Plug 'mattn/emmet-vim'

" highlighting/formatting
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
Plug 'chrisbra/Colorizer'
Plug 'luochen1990/rainbow'
Plug 'preservim/nerdcommenter'

call plug#end()
filetype indent on

set noswapfile
set ignorecase
set incsearch
set viminfo='20,<1000,s1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber

let g:plug_window='vert bo new'

runtime key.vim
runtime wsl.vim
runtime colo.vim

" colorizer
" auto launch:
let g:colorizer_auto_filetype='css,html,vue'

" indent-guides
let g:indentLine_char = '│'

" NERDTree
let NERDTreeShowHidden=1

" rainbow
let g:rainbow_active = 1

" vimtex
let g:vimtex_quickfix_mode = 0
let g:vimtex_syntax_conceal_disable = 1

" floaterm
let g:floaterm_position = 'bottomright'
let g:floaterm_height = 1.00
let g:floaterm_width = 0.35
let g:floaterm_shell = 'zsh'

" markdown highlighting
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'cpp', 'c', 'go', 'sh', 'css', 'javascript']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
set conceallevel=0
let g:indentLine_fileTypeExclude = ['json','markdown']
" save cursor position after exit
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" html indent on `=`
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"

autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab