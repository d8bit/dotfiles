-- Terraform / AWS helpers:
--   :Tf <args>   run terraform in a terminal split, in the current file's dir
--   <leader>ti / tv / tp / tf   init / validate / plan / fmt (terraform buffers)
--   statusline   DEPLOY_ENV (from envload), AWS profile/region, tf workspace
local M = {}

-- Same list as ENV_PROTECTED in scripts/env_indicator.sh
local protected = { prod = true, pro = true, production = true, admin = true }

local function file_dir()
  local name = vim.api.nvim_buf_get_name(0)
  return name ~= '' and vim.fs.dirname(name) or vim.fn.getcwd()
end

-- Runs through an interactive zsh so the `terraform` wrapper from
-- env_indicator.sh asks for confirmation on apply/destroy/import in prod.
local function terraform(args)
  vim.cmd('botright 15new')
  vim.fn.jobstart({ 'zsh', '-ic', 'terraform ' .. args }, { term = true, cwd = file_dir() })
  vim.cmd.startinsert()
end

local subcommands = {
  'init', 'validate', 'plan', 'apply', 'destroy', 'fmt', 'output', 'show',
  'state', 'import', 'workspace', 'providers', 'console', 'graph', 'test', 'refresh',
}

vim.api.nvim_create_user_command('Tf', function(o) terraform(o.args) end, {
  nargs = '+',
  desc = 'Run terraform in the current file\'s directory',
  complete = function(lead, line)
    if #vim.split(line, '%s+') > 2 then return {} end
    return vim.tbl_filter(function(c) return vim.startswith(c, lead) end, subcommands)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('Terraform', { clear = true }),
  pattern = { 'terraform', 'terraform-vars' },
  callback = function(ev)
    local map = function(lhs, args, desc)
      vim.keymap.set('n', lhs, function() terraform(args) end, { buffer = ev.buf, desc = desc })
    end
    map('<leader>ti', 'init', 'terraform init')
    map('<leader>tv', 'validate', 'terraform validate')
    map('<leader>tp', 'plan', 'terraform plan')
    map('<leader>tf', 'fmt -recursive', 'terraform fmt -recursive')
  end,
})

-- Format terraform on save (terraform-ls runs `terraform fmt`)
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('TerraformFmt', { clear = true }),
  pattern = { '*.tf', '*.tfvars', '*.tftest.hcl' },
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = 'terraformls' }) > 0 then
      vim.lsp.buf.format({ bufnr = ev.buf, name = 'terraformls', timeout_ms = 2000 })
    end
  end,
})

-- Statusline -----------------------------------------------------------------

local function tf_workspace()
  if not vim.tbl_contains({ 'terraform', 'terraform-vars' }, vim.bo.filetype) then return nil end
  if vim.env.TF_WORKSPACE then return vim.env.TF_WORKSPACE end
  local dir = vim.fs.find('.terraform', { upward = true, type = 'directory', path = file_dir() })[1]
  if not dir then return nil end
  local f = io.open(dir .. '/environment')
  if not f then return 'default' end
  local ws = vim.trim(f:read('*a'))
  f:close()
  return ws
end

function M.statusline()
  local parts = {}
  local env = vim.env.DEPLOY_ENV
  if env and env ~= '' then
    table.insert(parts, protected[env] and ('⚠ ' .. env:upper()) or ('[' .. env .. ']'))
  end
  local profile = vim.env.AWS_PROFILE or vim.env.AWS_VAULT
  local region = vim.env.AWS_REGION or vim.env.AWS_DEFAULT_REGION
  if profile or region then
    table.insert(parts, 'aws:' .. table.concat(vim.tbl_filter(function(v) return v end,
      { profile, region }), '/'))
  end
  local ws = tf_workspace()
  if ws then table.insert(parts, 'tf:' .. ws) end
  return table.concat(parts, ' ')
end

-- lualine component: the whole segment turns red in a protected environment
M.lualine = {
  M.statusline,
  color = function()
    if protected[vim.env.DEPLOY_ENV or ''] then
      return { fg = '#ffffff', bg = '#c02020', gui = 'bold' }
    end
  end,
}

return M
