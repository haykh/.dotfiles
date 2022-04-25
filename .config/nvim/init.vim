call plug#begin()
" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" filesystem
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" looks
Plug 'glepnir/oceanic-material'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" language specific
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'
Plug 'digitaltoad/vim-pug'
Plug 'bfrg/vim-cpp-modern'
Plug 'lervag/vimtex'

" highlighting/formatting
Plug 'thaerkh/vim-indentguides'
Plug 'chrisbra/Colorizer'
Plug 'luochen1990/rainbow'
Plug 'preservim/nerdcommenter'

" formatting @nvim
Plug 'mhartington/formatter.nvim'

" copilot @nvim
Plug 'github/copilot.vim'

" terminal @nvim
Plug 'voldikss/vim-floaterm'

" telescope + extensions @nvim
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'xiyaowong/telescope-emoji.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'olacin/telescope-gitmoji.nvim'

" search/replace @nvim
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'windwp/nvim-spectre'
call plug#end()
filetype  indent on

let g:plug_window = 'vert bo new'

" loading telescope + plugins @nvim
lua << EOF
require("telescope")
require("telescope").load_extension("emoji")
require("telescope").load_extension("file_browser")
require('telescope').load_extension("gitmoji")
require("telescope-emoji").setup({
  action = function(emoji)
  vim.fn.setreg("", emoji.value)
  print([[Press p or "*p to paste this emoji]] .. emoji.value)
  end,
})
EOF

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

" clang-format
lua << EOF
require('formatter').setup({
  filetype = {
    cpp = {
       function()
          return {
            exe = "clang-format",
            args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
            stdin = true,
            cwd = vim.fn.expand('%:p:h')
          }
        end
    },
  }
})
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.cpp,*.c,*.hpp,*.h FormatWrite
augroup END
]], true)
EOF

" NERDTree
let NERDTreeShowHidden=1
nnoremap <leader>nt <cmd>NERDTreeToggle<cr>

" indentation guides
let g:indentguides_spacechar = '│'
let g:indentguides_tabchar = '│'
let g:indentguides_toggleListMode = 0
let g:indentguides_ignorelist = ['markdown']

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme='kolor'

" rainbow
let g:rainbow_active = 1

" vimtex
let g:vimtex_quickfix_mode = 0
let g:vimtex_syntax_conceal_disable = 1

" floaterm
tnoremap <Leader>ff <C-\><C-n><C-w>w
tnoremap <Leader>fn <C-\><C-n>
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'
let g:floaterm_keymap_toggle = '<Leader>fs'
let g:floaterm_position = 'topright'
let g:floaterm_height = 0.35
let g:floaterm_width = 0.45
"let g:floaterm_wintype = 'split'

nnoremap <leader>tf <cmd>Telescope file_browser<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tr <cmd>Telescope registers<cr>
nnoremap <leader>th <cmd>Telescope man_pages<cr>
nnoremap <leader>te <cmd>Telescope emoji<cr>
nnoremap <leader>gm <cmd>Telescope gitmoji<cr>

" search/replace @nvim
lua << EOF
require('spectre').setup({
  live_update = true,
})
EOF
nnoremap <leader>S <cmd>lua require('spectre').open()<CR>
