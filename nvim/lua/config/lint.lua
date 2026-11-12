-- Linters that aren't language servers (nvim-lint). Results show up as regular
-- diagnostics, alongside the LSP ones (<leader>a for details).
-- Each linter prefers the project's vendor/bin/ binary, else the global one,
-- and is skipped silently if neither is installed.
local lint = require('lint')

lint.linters_by_ft = {
  php = { 'phpcs', 'phpmd' },
  terraform = { 'tflint', 'trivy' },
  dockerfile = { 'hadolint' },
  yaml = { 'actionlint', 'cfn_lint' },
  json = { 'cfn_lint' },
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

-- tflint: lint the file's module directory (not the whole repo from the cwd)
-- using the nearest .tflint.hcl above it, e.g. one enabling the AWS ruleset
-- (run `tflint --init` once to download it). Reported paths are relative to
-- nvim's cwd, as the default parser expects.
local tflint = lint.linters.tflint
-- tflint lines/columns are 1-based; nvim-lint's parser passes them as-is
local tflint_parse = tflint.parser
local function tflint_parser(...)
  local diags = tflint_parse(...)
  for _, d in ipairs(diags) do
    d.lnum, d.end_lnum = d.lnum - 1, d.end_lnum - 1
    d.col, d.end_col = d.col - 1, d.end_col - 1
  end
  return diags
end
lint.linters.tflint = function()
  local args = { '--format=json', '--chdir=' .. vim.fn.expand('%:.:h') }
  local cfg = find_ruleset({ '.tflint.hcl' })
  if cfg then table.insert(args, '--config=' .. cfg) end
  return vim.tbl_extend('force', tflint, { args = args, parser = tflint_parser })
end

-- trivy: scan the whole module directory so variables/locals resolve, then
-- keep only the current file's results (the parser matches by file name)
local trivy = lint.linters.trivy
trivy.append_fname = false
trivy.args = {
  'fs', '--scanners', 'misconfig', '--format', 'json', '--quiet', '--skip-version-check',
  '--severity', 'MEDIUM,HIGH,CRITICAL', -- drop LOW noise; edit to taste
  function() return vim.fn.expand('%:p:h') end,
}

-- Some linters only make sense for certain files of a filetype
local function first_lines(n)
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, n, false), '\n')
end
local conditions = {
  actionlint = function() return vim.fn.expand('%:p'):find('/%.github/workflows/') ~= nil end,
  cfn_lint = function() return first_lines(30):find('AWSTemplateFormatVersion') ~= nil end,
}

-- Linters that are scripts for an interpreter that must also be installed
local runtimes = { phpcs = 'php', phpmd = 'php' }

local function available(name)
  if conditions[name] and not conditions[name]() then return false end
  if runtimes[name] and vim.fn.executable(runtimes[name]) ~= 1 then return false end
  local linter = lint.linters[name]
  if type(linter) == 'function' then linter = linter() end
  local cmd = linter.cmd
  if type(cmd) == 'function' then cmd = cmd() end
  return vim.fn.executable(cmd) == 1
end

-- FileType rather than BufReadPost: on open, BufReadPost runs before the
-- filetype is detected (filetypedetect's autocmds are defined after init.lua)
vim.api.nvim_create_autocmd({ 'FileType', 'BufWritePost' }, {
  group = vim.api.nvim_create_augroup('Lint', { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= '' or ev.buf ~= vim.api.nvim_get_current_buf() then return end
    local names = vim.tbl_filter(available, lint.linters_by_ft[vim.bo.filetype] or {})
    if #names > 0 then lint.try_lint(names) end
  end,
})
