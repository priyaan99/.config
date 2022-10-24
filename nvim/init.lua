-- Resource https://bryankegley.me/posts/nvim-getting-started/
--
--local to buffer config
vim.bo.expandtab = true
vim.bo.autoindent = true 
vim.bo.smartindent = true 
vim.bo.swapfile = false 

--global cofig
vim.o.scrolloff=10
vim.o.sidescrolloff=5
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.termguicolors = true
vim.o.ruler = true
vim.o.showcmd = true
vim.o.syntax = 'on'
vim.o.backup = false
vim.o.hidden = true
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.completeopt='menuone,noinsert,noselect'
vim.o.hls = false 

--local to window config
vim.wo.number = true
vim.wo.relativenumber = true
vim.signcoloumn = 'yes'
vim.wo.wrap = false
------------------------------------------------------
------------------------------------------------------

local keymap = vim.api.nvim_set_keymap
keymap('i', 'jj', '<Esc>l', {})
keymap('i', 'JJ', '<Esc>l', {})

keymap('n', '<c-q>', '<Esc>:wq<CR>', {})
keymap('n', '<c-w>', '<Esc>:w<CR>', {})

local opts = { noremap = true }
keymap('n', '<c-j>', '<c-w>j', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)

keymap('n', '+', '<C-W>+', opts)
keymap('n', '-', '<C-W>-', opts)
keymap('n', '<', '<C-W><', opts)
keymap('n', '>', '<C-W>>', opts)

------------------------------------------------------
------------------------------------------------------

-- Steps to setup packer
-- 1. copy paste this text
-- 2. run :PackerCompile and ther :PackerInstall to install plugin

local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require'packer'
local util = require'packer.util'

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

--- startup and add configure plugins
packer.startup(function()
  local use = use
  -- add you plugins here like:
  -- use 'neovim/nvim-lspconfig'
    use { "ellisonleao/gruvbox.nvim" }
    use { "nvim-treesitter/nvim-treesitter" }
    use { "neovim/nvim-lspconfig" }
    use { "nvim-lua/completion-nvim" }
    use { "williamboman/nvim-lsp-installer" }
    use { "nvim-lua/popup.nvim" }
    use { "nvim-lua/plenary.nvim" }
    use { "nvim-lua/telescope.nvim" }
    use { "jremmen/vim-ripgrep" }

    --use { 'prettier/vim-prettier', run = "yarn install" }
    --[[
    use {
      "neovim/nvim-lspconfig",
      opt = true,
      event = "BufReadPre",
      wants = { "nvim-lsp-installer" },
      config = function()
        require("config.lsp").setup()
      end",
      requires = {
        "williamboman/nvim-lsp-installer",
      },
    }
    --]]
  end
)

-------------------------------------------------------------
-------------------------------------------------------------

--gruv-box 
vim.o.background = "dark"

-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = false, -- will make italic comments and special strings
  inverse = true, -- invert background for search, diffs, statuslines and errors
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  contrast = "", -- can be "hard" or "soft"
  overrides = {},
})
vim.cmd("colorscheme gruvbox")

----------------------------------------------------------------
----------------------------------------------------------------
--tree-sitter

local configs = require'nvim-treesitter.configs'

configs.setup {
  ensure_installed = { "c", "lua", "rust" },
  sync_install = false,

  highlight = {
      enable = true,
  },
  -- indent = { enable = false, },

  incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
  },

}

-- for folding --
vim.opt.foldmethod = "expr"
vim.opt.foldexpr ="nvim_treesitter#foldexpr()"

----------------------------------------------------------------
----------------------------------------------------------------
-- lsp config


local lsp_installer = require("nvim-lsp-installer");

lsp_installer.on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)

---- ::: KEYMAP ::: ----

--specific to lsp
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
--key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

key_mapper('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
key_mapper('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
key_mapper('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_mapper('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')

----------------------------------------------------------------
----------------------------------------------------------------
