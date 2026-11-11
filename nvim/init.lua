-- Neovim config (requires Neovim >= 0.12 for the built-in vim.pack manager)
--
-- Plugins:  :lua vim.pack.update()   update (review, then :write to confirm)
--           nvim-pack-lock.json      pinned revisions, keep it in git
vim.g.mapleader = '\\'

require('config.options')
require('config.plugins')
require('config.lsp')
require('config.lint')
require('config.keymaps')
