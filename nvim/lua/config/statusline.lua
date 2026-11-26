-- lualine theme switching
--   :LualineTheme <name>   switch theme (tab-completes bundled themes)
--   :LualineTheme          pick one from a list
-- The choice is saved and restored on the next start; 'auto' follows the
-- active colorscheme.

local M = {}

local state_file = vim.fn.stdpath('state') .. '/lualine_theme'

function M.saved()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  return ok and lines[1] and lines[1] ~= '' and lines[1] or 'auto'
end

function M.themes()
  local names = {}
  for _, f in ipairs(vim.api.nvim_get_runtime_file('lua/lualine/themes/*.lua', true)) do
    names[vim.fn.fnamemodify(f, ':t:r')] = true
  end
  names = vim.tbl_keys(names)
  table.sort(names, function(a, b) return a:lower() < b:lower() end)
  return names
end

function M.set(name)
  if not vim.tbl_contains(M.themes(), name) then
    vim.notify('lualine: unknown theme ' .. name, vim.log.levels.ERROR)
    return
  end
  local cfg = require('lualine').get_config()
  cfg.options.theme = name
  require('lualine').setup(cfg)
  vim.fn.writefile({ name }, state_file)
end

vim.api.nvim_create_user_command('LualineTheme', function(opts)
  if opts.args ~= '' then return M.set(opts.args) end
  vim.ui.select(M.themes(), { prompt = 'lualine theme (current: ' .. M.saved() .. ')' }, function(choice)
    if choice then M.set(choice) end
  end)
end, {
  nargs = '?',
  desc = 'Switch lualine theme',
  complete = function(lead)
    return vim.tbl_filter(function(n) return n:lower():find(lead:lower(), 1, true) == 1 end, M.themes())
  end,
})

return M
