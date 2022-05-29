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
Plug 'posva/vim-vue'

" auto-completion
Plug 'mattn/emmet-vim'

" highlighting/formatting
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
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

call plug#end()
filetype indent on

let g:plug_window='vert bo new'

lua << EOF
-- loading telescope + extensions @nvim
require('telescope').setup({
extensions = {
  file_browser = {
    theme = "ivy",
    hidden = true,
    grouped = true,
    sorting_strategy = 'ascending',
    display_stat = false,
    respect_gitignore = true,
    }
  }
})

require("telescope-emoji").setup({
action = function(emoji)
vim.fn.setreg("", emoji.value)
end,
})
require("telescope").load_extension("emoji")
require("telescope").load_extension("file_browser")
require('telescope').load_extension("gitmoji")

-- treesitter @nvim
require("nvim-treesitter/configs").setup({
ensure_installed = { "c", "lua", "rust" },
highlight = {
  enable = true
  }
})

-- clang-format @nvim
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

" colorizer
" auto launch:
let g:colorizer_auto_filetype='css,html,vue'

" emmet-vim
"let g:user_emmet_leader_key='<Leader>'
let g:user_emmet_expandabbr_key = '<S-Tab>'

" oceanic
let g:oceanic_material_allow_bold=1
let g:oceanic_material_transparent_background=1

" indent-guides
let g:indentLine_char = '│'

" NERDTree
let NERDTreeShowHidden=1
nnoremap <leader>nt <cmd>NERDTreeToggle<cr>

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme='supernova'

" rainbow
let g:rainbow_active = 1

" vimtex
let g:vimtex_quickfix_mode = 0
let g:vimtex_syntax_conceal_disable = 1

" floaterm
tnoremap <Leader>ff <C-\><C-n><C-w>w
tnoremap <Leader>fn <C-\><C-n>
tnoremap <Leader>f+ <cmd>FloatermUpdate --height=0.95<cr>
tnoremap <Leader>f- <cmd>FloatermUpdate --height=g:floaterm_height<cr>
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'
let g:floaterm_keymap_toggle = '<Leader>fs'
let g:floaterm_position = 'topright'
let g:floaterm_height = 0.35
let g:floaterm_width = 0.45

" telescope + extensions
nnoremap <leader>tf <cmd>Telescope file_browser<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tr <cmd>Telescope registers<cr>
nnoremap <leader>th <cmd>Telescope man_pages<cr>
nnoremap <leader>te <cmd>Telescope emoji theme=ivy<cr>
nnoremap <leader>gm <cmd>Telescope gitmoji<cr>

"------------------------------------------------------------------------------
"------ vanilla vim flags -----------------------------------------------------
"------------------------------------------------------------------------------
silent! colo oceanic_material
syntax on
hi Error NONE
hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi Directory ctermfg=Blue
inoremap jk <ESC>

set noswapfile
set ignorecase
set incsearch
set background=dark
set viminfo='20,<1000,s1000
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set number relativenumber
"set termguicolors

" markdown highlighting
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'cpp', 'c', 'go', 'sh', 'css', 'javascript']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
set conceallevel=0
" save cursor position after exit
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" for background to be transparent to terminal
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

" customize color highlightings
hi VertSplit cterm=NONE ctermfg=238 ctermbg=NONE
hi EndOfBuffer ctermfg=238
hi SignColumn ctermbg=NONE

" html indent on `=`
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"

" legacy
"" customize vertical separator
"set fillchars+=vert:│
"" ???
"set backspace=indent,eol,start
"" ???
"set hlsearch
"let CursorColumnI = 0 "the cursor column position in INSERT
