return {'github/copilot.vim', 'vim-airline/vim-airline', {
  'vim-airline/vim-airline-themes',
  config = function()
    vim.g.airline_powerline_fonts = 1
    vim.g.airline_theme = 'github_dark_default'
  end
}, 'tpope/vim-markdown', 'cespare/vim-toml', 'tikhomirov/vim-glsl', {
  -- colorizer
  'chrisbra/Colorizer',
  config = function()
    vim.g.colorizer_auto_filetype = 'css,html,vue,markdown,scss,less,javascript'
  end
}, {
  -- color scheme
  'projekt0n/github-nvim-theme',
  config = function()
    vim.cmd('colo github_dark_default')
  end
}, 'nvim-tree/nvim-web-devicons', 'tpope/vim-surround', {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
    require("scrollbar.handlers.gitsigns").setup()
  end
}, {
  -- file tree viewer
  'nvim-tree/nvim-tree.lua',
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    -- set nvim-tree.filters.git_ignored
  end,
  config = function()
    vim.api.nvim_set_keymap('n', '<Leader><Leader>', '<Cmd>NvimTreeToggle<CR>', {
      noremap = true,
      silent = true
    })
    require('nvim-tree').setup({
      filters = {
        git_ignored = false,
      }
    })
  end
}, {
  'romgrk/barbar.nvim',
  dependencies = {'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons'},
  init = function()
    vim.g.barbar_auto_setup = false
    vim.api.nvim_set_keymap('n', '<Leader>[', '<Cmd>BufferPrevious<CR>', {
      noremap = true,
      silent = true
    })
    vim.api.nvim_set_keymap('n', '<Leader>]', '<Cmd>BufferNext<CR>', {
      noremap = true,
      silent = true
    })
    vim.api.nvim_set_keymap('n', '<Leader>{', '<Cmd>BufferMovePrevious<CR>', {
      noremap = true,
      silent = true
    })
    vim.api.nvim_set_keymap('n', '<Leader>}', '<Cmd>BufferMoveNext<CR>', {
      noremap = true,
      silent = true
    })
    vim.api.nvim_set_keymap('n', '<Leader>c', '<Cmd>BufferClose<CR>', {
      noremap = true,
      silent = true
    })
    vim.api.nvim_set_keymap('n', '<Leader>p', '<Cmd>BufferPin<CR>', {
      noremap = true,
      silent = true
    })
  end,
  opts = {
    icons = {
      pinned = {
        button = '',
        filename = true
      }
    }
  }
}, {
  -- scrollbar
  'petertriho/nvim-scrollbar',
  config = function()
    require('scrollbar').setup({
      handle = {
        text = " ",
      },
      marks = {
        Search = { text = { ">", ">" } },
        Error = { text = { "-", "=" } },
        Warn = { text = { "-", "=" } },
        Info = { text = { "-", "=" } },
        Hint = { text = { "-", "=" } },
        Misc = { text = { "-", "=" } },
      }
    })
  end
}, {
  -- search highlighter
  'kevinhwang91/nvim-hlslens',
  config = function()
    local kopts = {
      noremap = true,
      silent = true
    }
    vim.api.nvim_set_keymap('n', 'n',
    [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'N',
    [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)

    require("scrollbar.handlers.search").setup({
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
        else
          indicator = ''
        end

        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= '' then
            text = ('[%s %d/%d]'):format(indicator, idx, cnt)
          else
            text = ('[%d/%d]'):format(idx, cnt)
          end
          chunks = {{' '}, {text, 'HlSearchLensNear'}}
        else
          text = ('[%s %d]'):format(indicator, idx)
          chunks = {{' '}, {text, 'HlSearchLens'}}
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end
    })
  end
}, {
  -- comment toggler
  'numToStr/Comment.nvim',
  opts = {
    toggler = {
      line = '<Leader>c<Space>',
      block = '<Leader>C<Space>'
    },
    opleader = {
      line = '<Leader>c<Space>',
      block = '<Leader>C<Space>'
    }
  },
  lazy = false
}, {
      -- rainbow delimiters for treesitter
      'HiPhish/rainbow-delimiters.nvim',
      config = function()
        local rainbow_delimiters = require 'rainbow-delimiters'
        require('rainbow-delimiters.setup').setup({
          strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local']
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks'
          },
          priority = {
            [''] = 110,
            lua = 210
          },
          highlight = {'RainbowDelimiterRed', 'RainbowDelimiterYellow', 'RainbowDelimiterBlue',
          'RainbowDelimiterOrange', 'RainbowDelimiterGreen', 'RainbowDelimiterViolet',
          'RainbowDelimiterCyan'}
        })
      end
    }, {
      -- telescope with plugins
      'nvim-telescope/telescope.nvim',
      dependencies = {'nvim-lua/plenary.nvim'},
      extensions = {
        file_browser = {
          theme = "ivy",
          hidden = true,
          grouped = true,
          sorting_strategy = 'ascending',
          display_stat = false,
          respect_gitignore = true
        },
        emoji = {
          action = function(emoji)
            vim.fn.setreg("", emoji.value)
          end
        }
      },
      config = function()
        require("telescope").load_extension("emoji")
        require("telescope").load_extension("file_browser")
        require("telescope").load_extension("gitmoji")

        vim.api.nvim_set_keymap('n', '<Leader>tf', '<Cmd>Telescope file_browser<CR>', {
          noremap = true,
          silent = true
        })
        vim.api.nvim_set_keymap('n', '<Leader>tg', '<Cmd>Telescope live_grep<CR>', {
          noremap = true,
          silent = true
        })
        vim.api.nvim_set_keymap('n', '<Leader>tr', '<Cmd>Telescope registers<CR>', {
          noremap = true,
          silent = true
        })
        vim.api.nvim_set_keymap('n', '<Leader>th', '<Cmd>Telescope man_pages<CR>', {
          noremap = true,
          silent = true
        })
        vim.api.nvim_set_keymap('n', '<Leader>te', '<Cmd>Telescope emoji theme=ivy<CR>', {
          noremap = true,
          silent = true
        })
        vim.api.nvim_set_keymap('n', '<Leader>gm', '<Cmd>Telescope gitmoji<CR>', {
          noremap = true,
          silent = true
        })

      end
    }, 'olacin/telescope-gitmoji.nvim', 'xiyaowong/telescope-emoji.nvim', 'nvim-telescope/telescope-file-browser.nvim'}
