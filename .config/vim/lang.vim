" html
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"

" markdown
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'cpp', 'c', 'go', 'sh', 'css', 'javascript', 'toml']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
set conceallevel=0

" go
autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
