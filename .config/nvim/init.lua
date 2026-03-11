-- Matt's neovim config
-- Leader key (space is the modern standard — all custom bindings start with <space>)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Core settings
-- ============================================================================
vim.opt.number = true              -- line numbers
vim.opt.relativenumber = true      -- relative line numbers (makes jumping easier: 5j, 12k)
vim.opt.mouse = "a"                -- mouse support (handy for scrolling/selecting)
vim.opt.ignorecase = true          -- case-insensitive search...
vim.opt.smartcase = true           -- ...unless you type a capital letter
vim.opt.hlsearch = true            -- highlight search results
vim.opt.incsearch = true           -- show matches as you type
vim.opt.wrap = false               -- no line wrapping
vim.opt.breakindent = true         -- wrapped lines respect indentation
vim.opt.tabstop = 2                -- tab width
vim.opt.shiftwidth = 2             -- indent width
vim.opt.expandtab = true           -- spaces instead of tabs
vim.opt.smartindent = true         -- auto-indent new lines
vim.opt.termguicolors = true       -- true color support
vim.opt.signcolumn = "yes"         -- always show sign column (prevents layout shift)
vim.opt.cursorline = true          -- highlight current line
vim.opt.scrolloff = 8              -- keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8          -- keep 8 columns visible left/right
vim.opt.splitright = true          -- new vertical splits go right
vim.opt.splitbelow = true          -- new horizontal splits go below
vim.opt.clipboard = "unnamedplus"  -- use system clipboard
vim.opt.undofile = true            -- persistent undo across sessions
vim.opt.updatetime = 250           -- faster CursorHold events (for gitsigns etc.)
vim.opt.timeoutlen = 300           -- time to wait for mapped sequence (which-key needs this)
vim.opt.completeopt = "menuone,noselect"
vim.opt.showmode = false           -- lualine shows the mode instead

-- ============================================================================
-- Basic keymaps (before plugins)
-- ============================================================================
-- Clear search highlight with Escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Move selected lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- ============================================================================
-- Plugin manager: lazy.nvim (auto-installs on first run)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugins
-- ============================================================================
require("lazy").setup({

  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- dark theme: latte, frappe, macchiato, mocha
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Treesitter: parser management (highlighting is built into nvim 0.11+)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Install parsers for languages you use
      local parsers = {
        "go", "gomod", "gosum",
        "lua", "vim", "vimdoc",
        "javascript", "typescript", "json", "yaml", "toml",
        "html", "css", "markdown", "markdown_inline",
        "bash", "dockerfile", "hcl", "terraform",
        "python", "rust", "ruby",
        "gitcommit", "git_rebase",
      }
      require("nvim-treesitter").install(parsers)

      -- Auto-enable treesitter highlighting when opening files
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- Telescope: fuzzy finder for everything
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
      })
      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })
      vim.keymap.set("n", "<leader>fs", builtin.git_status, { desc = "Git status" })
    end,
  },

  -- Oil: file browser as a buffer
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
    end,
  },

  -- Git signs in the gutter + inline blame
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = false, -- toggle with <leader>gb
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          map("n", "]h", gs.next_hunk, { desc = "Next git hunk" })
          map("n", "[h", gs.prev_hunk, { desc = "Previous git hunk" })
          map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle git blame" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = "",
          component_separators = "|",
        },
        sections = {
          lualine_c = { { "filename", path = 1 } }, -- show relative path
        },
      })
    end,
  },

  -- Which-key: shows available keybindings as you type
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 500,
      })
      wk.add({
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
      })
    end,
  },

  -- Auto-close brackets and quotes
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
    end,
  },

}, {
  -- lazy.nvim UI settings
  checker = { enabled = false }, -- don't auto-check for plugin updates
})
