-- Linters that aren't language servers (nvim-lint). Results show up as regular
-- diagnostics, alongside the LSP ones (<leader>a for details).
-- Each linter prefers the project's vendor/bin/ binary, else the global one,
-- and is skipped silently if neither is installed.
local lint = require('lint')

lint.linters_by_ft = {
  php = { 'phpcs', 'phpmd' },
}

-- Nearest project ruleset above the current file, if any
local function find_ruleset(names)
  return vim.fs.find(names, { upward = true, path = vim.fn.expand('%:p:h') })[1]
end

-- phpcs: project's phpcs.xml if present, else PSR-12
local phpcs = lint.linters.phpcs
table.insert(phpcs.args, 1, function()
  local ruleset = find_ruleset({ 'phpcs.xml', '.phpcs.xml', 'phpcs.xml.dist', '.phpcs.xml.dist' })
  return '--standard=' .. (ruleset or 'PSR12')
end)

-- phpmd: project's phpmd.xml if present, else nvim-lint's default rule sets
local phpmd = lint.linters.phpmd
local phpmd_default = phpmd.args[3]
phpmd.args[3] = function()
  return find_ruleset({ 'phpmd.xml', '.phpmd.xml', 'phpmd.xml.dist', '.phpmd.xml.dist' })
    or phpmd_default
end

local function available(name)
  local cmd = lint.linters[name].cmd
  if type(cmd) == 'function' then cmd = cmd() end
  return vim.fn.executable(cmd) == 1
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  group = vim.api.nvim_create_augroup('Lint', { clear = true }),
  callback = function()
    local names = vim.tbl_filter(available, lint.linters_by_ft[vim.bo.filetype] or {})
    if #names > 0 then lint.try_lint(names) end
  end,
})
