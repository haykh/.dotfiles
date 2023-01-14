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
    },
  emoji = {
    action = function(emoji)
      vim.fn.setreg("", emoji.value)
    end,
    }
  }
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
  python = {
    function()
    return {
      exe = "black",
      args = { "-" },
      stdin = 1,
      }
    end
    },
  fortran = {
    function()
    return {
      exe = "fprettify",
      args = { "-i 2", "-w 4", "--whitespace-assignment true", "--enable-decl --whitespace-decl true", "--whitespace-relational true", "--whitespace-logical true", "--whitespace-plusminus true", "--whitespace-multdiv true", "--whitespace-print true", "--whitespace-type true", "--whitespace-intrinsics true", "--enable-replacements", "-l 1000" },
      stdin = 1,
      }
    end
    },
  }
})
vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.cpp,*.c,*.hpp,*.h,*.py,*.F90,*.F08,*.F FormatWrite
augroup END
]], true)
