--OPTIONS 
vim.api.nvim_exec('language en_US', true)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.cmd [[ set noswapfile ]]

--Line numbers
vim.wo.number = true

-- KEYMAPS
-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if  not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  --"folke/which-key.nvim",
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {'nvim-lualine/lualine.nvim', dependencies={'nvim-tree/nvim-web-devicons'}},
  'sainnhe/gruvbox-material',
 -- { "blazkowolf/gruber-darker.nvim" },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  'rlane/pounce.nvim',
  'wfxr/minimap.vim',
  { "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }},
  'nvim-treesitter/nvim-treesitter',
  'wfxr/minimap.vim',
  "AckslD/nvim-neoclip.lua",

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    --config = function()
      --  require("nvim-tree").setup {}
      --end,
    },
    --'wfxr/minimap.vim'
    -- "AckslD/nvim-neoclip.lua",
  })

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- set termguicolors to enable highlight groups
  vim.opt.termguicolors = true

  -- empty setup using defaults
  --require("nvim-tree").setup()

  -- OR setup with some options
  require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  })

  vim.cmd [[  if has('termguicolors')
  set termguicolors
  endif ]]
  vim.cmd [[ set background=light ]]
  vim.cmd [[ set background=dark ]]
  vim.cmd [[ let g:gruvbox_material_background = 'soft'  ]]
  vim.cmd.colorscheme "gruvbox-material"

 -- vim.cmd.colorscheme("gruber-darker")

  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'gruvbox-material',
    },
    sections = {
      lualine_a = {
        {
          'filename',
          path = 1,
        },
      }
    }
  }

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls"}
  })


  require("lspconfig").lua_ls.setup {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
          disable = { "lowercase-global" }
        },
        workspace = {
          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.stdpath "config" .. "/lua"] = true,
          },
        },
      },
    }
  }


  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
      enable = true,

      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- disable = { "c", "rust" },
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }


  -- require('telescope').setup()
  require("telescope").setup {
    extensions = {
      file_browser = {
        theme = "ivy",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          ["i"] = {
            -- your custom insert mode mappings
          },
          ["n"] = {
            -- your custom normal mode mappings
          },
        },
      },
    },
  }
  require("telescope").load_extension "file_browser"
  require("telescope").load_extension "neoclip"
  --require('neoclip').setup()


  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = 'Find Files'})
  vim.keymap.set('n', '<leader>fb', ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {desc = 'File Browser'})


  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Find Grep'})
  vim.keymap.set('n', '<leader>fv', builtin.buffers, {desc = 'Find Buffer'})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = 'Find in Help'})
  vim.keymap.set('n', '<leader>fd', vim.lsp.buf.hover, {desc = 'Show Documentation'})
  vim.keymap.set('n', '<leader>fl', builtin.lsp_references, {desc = 'Find in LSP ref'})
  vim.keymap.set('n', '<leader>gd', "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true, desc = 'Goto Definition'})
  vim.keymap.set('n', '<leader>tt', ":NvimTreeToggle<CR>", {noremap = true, silent=false, desc = 'Toggle Tree'} )
  vim.keymap.set('n', '<leader>mm', ":MinimapToggle<CR>", {noremap = true, silent=false, desc = 'Toggle Minimap'} )



  --  vim.keymap.set('n', 'p', function() require'pounce'.pounce{} end, {desc = 'Start Pounce'})
