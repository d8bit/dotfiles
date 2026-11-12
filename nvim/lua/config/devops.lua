-- Terraform / AWS helpers:
--   :Tf <args>   run terraform in a terminal split, in the current file's dir
--   <leader>ti / tv / tp / tf   init / validate / plan / fmt (terraform buffers)
--   statusline   DEPLOY_ENV (from envload), AWS profile/region, tf workspace,
--                kube context (YAML/Helm buffers)
--   Kubernetes manifests get schema validation wherever they are
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

-- Kubernetes -----------------------------------------------------------------
-- yamlls can't tell a manifest from any other YAML, so files whose top-level
-- keys include apiVersion and kind get the Kubernetes schema (plus CRDs from
-- yamlls' CRD catalog, e.g. ExternalSecret, Karpenter), wherever they live.
local k8s_files = {}

local function is_manifest(buf)
  local api, kind = false, false
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, 200, false)) do
    api = api or line:find('^apiVersion:%s*%S') ~= nil
    kind = kind or line:find('^kind:%s*%S') ~= nil
    if api and kind then return true end
  end
  return false
end

local function k8s_schema(buf)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == '' or k8s_files[path] or not is_manifest(buf) then return end
  local client = vim.lsp.get_clients({ bufnr = buf, name = 'yamlls' })[1]
  if not client then return end
  k8s_files[path] = true
  local settings = client.settings
  settings.yaml.schemas.kubernetes = vim.tbl_keys(k8s_files)
  client:notify('workspace/didChangeConfiguration', { settings = settings })
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('K8sSchema', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'yamlls' then k8s_schema(ev.buf) end
  end,
})
-- a new file becomes a manifest once apiVersion/kind are written
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'K8sSchema',
  pattern = { '*.yaml', '*.yml' },
  callback = function(ev) k8s_schema(ev.buf) end,
})

-- current-context of the active kubeconfig (first file in $KUBECONFIG),
-- re-read only when the file changes (kubectl config use-context, kubectx)
local kube = { mtime = nil, context = nil }
local function kube_context()
  local file = vim.split(vim.env.KUBECONFIG or '', ':', { trimempty = true })[1]
    or vim.fs.joinpath(vim.env.HOME, '.kube', 'config')
  local stat = vim.uv.fs_stat(file)
  if not stat then return nil end
  if kube.mtime ~= stat.mtime.sec then
    kube.mtime, kube.context = stat.mtime.sec, nil
    for line in io.lines(file) do
      local ctx = line:match('^current%-context:%s*["\']?([^"\'%s]+)')
      if ctx then kube.context = ctx break end
    end
  end
  return kube.context
end

local k8s_fts = { yaml = true, helm = true, ['yaml.helm-values'] = true }

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
  local ctx = k8s_fts[vim.bo.filetype] and kube_context()
  if ctx then table.insert(parts, 'k8s:' .. ctx) end
  return table.concat(parts, ' ')
end

-- a kube context counts as protected if a protected name is one of its words
-- (aks-prod-weu, prod/eks-main), so production clusters also turn red
local function protected_context(ctx)
  for name in pairs(protected) do
    if ctx:find('%f[%w]' .. name .. '%f[%W]') then return true end
  end
  return false
end

-- lualine component: the whole segment turns red in a protected environment
M.lualine = {
  M.statusline,
  color = function()
    local ctx = k8s_fts[vim.bo.filetype] and kube_context()
    if protected[vim.env.DEPLOY_ENV or ''] or (ctx and protected_context(ctx)) then
      return { fg = '#ffffff', bg = '#c02020', gui = 'bold' }
    end
  end,
}

return M
