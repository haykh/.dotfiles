call plug#begin()
" git diff
Plug 'airblade/vim-gitgutter'

" looks
Plug 'glepnir/oceanic-material'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'thaerkh/vim-indentguides'

" highlighting
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'
Plug 'chrisbra/Colorizer'
Plug 'digitaltoad/vim-pug'

" shortcuts 
Plug 'preservim/nerdcommenter'

" latex
Plug 'lervag/vimtex'

" terminal @nvim
Plug 'voldikss/vim-floaterm'

" telescope @nvim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'xiyaowong/telescope-emoji.nvim'

call plug#end()
filetype  indent on

" vanilla vim flags
colo oceanic_material
syntax on
hi Error NONE
hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi Directory ctermfg=Blue
inoremap jk <ESC>
" save cursor position after insert mode
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
"let CursorColumnI = 0 "the cursor column position in INSERT

set noswapfile
set ignorecase
set incsearch
set hlsearch
set background=dark
set viminfo='20,<1000,s1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
set backspace=indent,eol,start

" markdown highlighting
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'cpp', 'c', 'go', 'sh', 'css', 'javascript']
set conceallevel=0

"" for background to be transparent to terminal
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

" customize vertical separator
set fillchars+=vert:│
hi VertSplit cterm=NONE ctermfg=238 ctermbg=NONE
" customize color highlightings
hi EndOfBuffer ctermfg=238
hi SignColumn ctermbg=NONE

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 75

" indentation guides
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
let g:indentguides_toggleListMode = 0
let g:indentguides_ignorelist = ['markdown']

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme='kolor'

" vimtex
let g:vimtex_quickfix_mode = 0
let g:vimtex_syntax_conceal_disable = 1

" floaterm
tnoremap <Leader>ff <C-\><C-n><C-w>w
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'
let g:floaterm_keymap_hide = '<Leader>fh'
let g:floaterm_keymap_show = '<Leader>fs'
let g:floaterm_position = 'topright'
let g:floaterm_height = 0.35
let g:floaterm_width = 0.45
"let g:floaterm_wintype = 'split'

lua require('telescope').setup{}
lua require('telescope').load_extension('emoji')
lua << EOF
require("telescope-emoji").setup({
  action = function(emoji)
  vim.fn.setreg("*", emoji.value)
  print([[Press p or "*p to paste this emoji]] .. emoji.value)
  end,
})
EOF

nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>th <cmd>Telescope help_tags<cr>
nnoremap <leader>te <cmd>Telescope emoji<cr>
