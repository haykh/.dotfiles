inoremap jk <ESC>

" emmet-vim
let g:user_emmet_expandabbr_key = '<S-Tab>'

" NERDTree
nnoremap <leader><leader> <cmd>NERDTreeToggle<cr>

" floaterm
"tnoremap <Leader>ff <C-\><C-n><C-w>w
tnoremap <Leader>fn <C-\><C-n>
tnoremap jk <C-\><C-n><C-w>w
"tnoremap <Leader>f= <cmd>FloatermUpdate --height=0.95<cr>
"tnoremap <Leader>f_ <cmd>FloatermUpdate --height=g:floaterm_height<cr>
"tnoremap <Leader>f+ <cmd>FloatermUpdate --width=0.95<cr>
"tnoremap <Leader>f- <cmd>FloatermUpdate --width=g:floaterm_width<cr>
let g:floaterm_keymap_new = '<Leader>ft'
let g:floaterm_keymap_kill = '<Leader>fq'
let g:floaterm_keymap_toggle = '<Leader>fs'

" telescope + extensions
nnoremap <leader>tf <cmd>Telescope file_browser<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tr <cmd>Telescope registers<cr>
nnoremap <leader>th <cmd>Telescope man_pages<cr>
nnoremap <leader>te <cmd>Telescope emoji theme=ivy<cr>
nnoremap <leader>gm <cmd>Telescope gitmoji<cr>

" LSP
nnoremap <leader>ld <cmd>Telescope lsp_definitions<cr>
nnoremap <leader>lt <cmd>Telescope lsp_type_definitions<cr>
nnoremap <leader>li <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>ls <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>lr <cmd>Telescope lsp_references<cr>

" tabs
nnoremap <leader>[ <Cmd>BufferPrevious<CR>
nnoremap <leader>] <Cmd>BufferNext<CR>
nnoremap <leader>{ <Cmd>BufferMovePrevious<CR>
nnoremap <leader>} <Cmd>BufferMoveNext<CR>
nnoremap <leader>c <Cmd>BufferClose<CR>