local opt = vim.opt

-- nvim-tree replaces netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.mouse = 'a'
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.colorcolumn = '81'
opt.signcolumn = 'yes'
opt.list = true
opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.splitbelow = true
opt.splitright = true
opt.switchbuf:append({ 'usetab', 'newtab' })

opt.timeoutlen = 1000
opt.ttimeoutlen = 0

opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true -- stored in stdpath('state')/undo, not /tmp

opt.wildignore:append({ 'vendor/**', 'node_modules/**' })
opt.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }

-- 2-space indent for these filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'eruby', 'ruby', 'yaml', 'html', 'blade', 'json', 'javascript',
    'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'terraform', 'hcl', 'lua',
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

vim.filetype.add({
  extension = { hcl = 'terraform', xt = 'xt' },
  pattern = {
    ['.*%.DockerFile'] = 'dockerfile',
    ['.*%.es%.conf'] = 'nginx',
  },
})

-- Close quickfix when it's the last window left
vim.api.nvim_create_autocmd('WinEnter', {
  group = vim.api.nvim_create_augroup('QFClose', { clear = true }),
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.bo.buftype == 'quickfix' then
      vim.cmd.quit()
    end
  end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})
