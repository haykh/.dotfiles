local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("lazy").setup("plugins")

-- Set background
vim.o.background = 'dark'

-- Enable true colors
vim.o.termguicolors = true

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Highlight settings
vim.cmd('hi Error NONE')
vim.cmd('hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE')
vim.cmd('hi Directory ctermfg=Blue')

-- Customize color highlightings for background to be transparent to terminal
vim.cmd('hi nonText ctermbg=NONE')
vim.cmd('hi VertSplit cterm=NONE ctermfg=238 ctermbg=NONE')
vim.cmd('hi EndOfBuffer ctermfg=238')
vim.cmd('hi SignColumn ctermbg=NONE')
vim.cmd('hi LineNr ctermfg=NONE guibg=NONE')

-- main colors
vim.cmd('hi Normal ctermbg=NONE guibg=NONE')
vim.cmd('hi NormalNC ctermbg=NONE guibg=NONE')
vim.cmd('hi NvimTreeNormal guibg=NONE')

-- floaterm colors
vim.cmd('hi FloatermBorder guibg=NONE')
vim.cmd('hi FloatermNC guifg=GRAY guibg=NONE')

-- tab-bar colors
vim.cmd('hi BufferTabpageFill guibg=NONE')

-- scrollbar colors
vim.cmd('hi ScrollbarSearch guifg=ORANGE')
vim.cmd('hi ScrollbarSearchHandle guifg=WHITE')

-- search highlight
vim.cmd('hi HlSearchLens guibg=NONE guifg=ORANGE')

vim.g.floaterm_keymap_new = "<Leader>ft"
vim.g.floaterm_keymap_kill = "<Leader>fq"
vim.g.floaterm_keymap_toggle = "<Leader>fs"

-- Enable filetype indent
vim.cmd('filetype indent on')

-- Insert mode mapping
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {
    noremap = true
})

-- Set options
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true

-- Autocommands
vim.api.nvim_create_autocmd('BufReadPost', {
    once = true,
    callback = function()
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.cmd("normal g'\"zz")
        end
    end
})
vim.api.nvim_create_autocmd({'BufNew','BufRead'}, {
    pattern = '*.asm',
    callback = function()
        vim.bo.filetype = 'nasm'
    end
})

-- for WSL only
local function InWSL()
    local uname = vim.fn.system('uname'):gsub('\n', '')
    if uname == 'Linux' then
        local lines = vim.fn.readfile("/proc/version")
        if string.find(lines[1], "Microsoft") then
            return true
        end
    end
    return false
end

-- WSL yank support
if InWSL() then
    vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe'
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
        },
        cache_enabled = 0
    }
end

function Helper()
    local keymap = {{
        key = "H/M/L",
        action = "move cursor to top/middle/bottom"
    }, {
        key = "z[b|z|t]",
        action = "raise/center/lower view on cursor"
    }, {
        key = "<C-[e|y]>",
        action = "scroll one line up/down"
    }, {
        key = "<C-[o|i]>",
        action = "prev/next jump"
    }, {
        key = "<Leader>l[d|t|i]",
        action = "lsp definition/type/implementation"
    }, {
        key = "<Leader>t[f|g|h]",
        action = "file browser/live grep/man pages"
    }, {
        key = "<Leader>l",
        action = "nohlsearch"
    }, {
        key = "<Leader>qq",
        action = "stop lsp"
    }, {
        key = "<C-[a|x]>",
        action = "increment/decrement number"
    }}
    local quit_msg = "[`q` to close]"

    -- Define the size of the floating window
    local width = 80
    local height = #keymap + 4
    local sep_col = 30

    -- Create the scratch buffer displayed in the floating window
    local buf = vim.api.nvim_create_buf(false, true)

    -- create the lines to draw a box
    local top = '╔' .. string.rep('═', width - 2) .. '╗'
    local mid = '║' .. string.rep(' ', width - 2) .. '║'
    -- local bottom = '╚' .. string.rep('═', width - 2) .. '╝'
    local bottom = '╚' .. string.rep('═', width - 2 - #quit_msg) .. quit_msg .. '╝'
    local lines = {top}
    for _ = 1, height - 2 do
        table.insert(lines, mid)
    end
    table.insert(lines, bottom)
    -- set the box in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local offset = 1
    for i = 1, #keymap do
        local key = keymap[i].key
        local action = keymap[i].action
        -- Now you can use `key` and `action` in the order you specified
        local current_row = 1 + offset
        offset = offset + 1
        vim.api.nvim_buf_set_text(buf, current_row, sep_col - #key, current_row, sep_col, {key})
        vim.api.nvim_buf_set_text(buf, current_row, sep_col + 1, current_row, sep_col + 2, {":"})
        vim.api.nvim_buf_set_text(buf, current_row, sep_col + 3, current_row, sep_col + 3 + #action, {action})
    end

    -- Set mappings in the buffer to close the window easily
    local closingKeys = {'q', '<Leader>/'}
    for _, closingKey in ipairs(closingKeys) do
        vim.api.nvim_buf_set_keymap(buf, 'n', closingKey, '<Cmd>close<CR>', {
            silent = true,
            nowait = true,
            noremap = true
        })
    end

    -- Create the floating window
    local ui = vim.api.nvim_list_uis()[1]
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (ui.width / 2) - (width / 2),
        row = (ui.height / 2) - (height / 2),
        anchor = 'NW',
        style = 'minimal'
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Change highlighting
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:ErrorFloat')
end

vim.api.nvim_set_keymap('n', '<Leader>/', '<Cmd>lua Helper()<CR>', {
    noremap = true
})
