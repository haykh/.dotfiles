colo onehalfdark
set background=dark
set termguicolors

" airline
let g:airline_powerline_fonts = 1
let g:airline_theme='onehalfdark'

syntax on
hi Error NONE
hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi Directory ctermfg=Blue

" customize color highlightings
" for background to be transparent to terminal
hi nonText ctermbg=NONE
hi VertSplit cterm=NONE ctermfg=238 ctermbg=NONE
hi EndOfBuffer ctermfg=238
hi SignColumn ctermbg=NONE
hi Normal ctermbg=NONE guibg=NONE
hi LineNr ctermfg=NONE guibg=NONE
let g:gitgutter_set_sign_backgrounds = 1

" floaterm
hi FloatermBorder guibg=NONE guifg=NONE
