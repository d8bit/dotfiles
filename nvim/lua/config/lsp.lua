-- Built-in LSP client; server definitions come from nvim-lspconfig's lsp/ dir.
-- A server is enabled only if its executable is on $PATH. Mason installs them
-- (see config/mason.lua); a global or project install works too.
local servers = {
  'intelephense', -- PHP (preferred)
  'phpactor',     -- PHP (fallback if intelephense isn't installed)
  'pyright',
  'tsc',          -- TS/JS: TypeScript 7 native server (`tsc --lsp`)
  'vtsls',        -- .vue only: TS 7 has no tsserver plugins yet
  'vue_ls',
  'terraformls',
  'lua_ls',
  'yamlls',
  'jsonls',
  'helm_ls',
  'bashls',
  'dockerls',
  'texlab',
  'jdtls',        -- Java (needs a JDK 25+ on $PATH / JAVA_HOME)
}

-- Some lspconfig servers define `cmd` as a function; name their binaries here.
-- `tsc` runs the `tsc` binary from Mason's `tsc` package (TypeScript 7).
local binaries = {
  tsc = { 'tsc' },
  yamlls = { 'yaml-language-server' },
  jsonls = { 'vscode-json-language-server' },
  helm_ls = { 'helm_ls' },
  jdtls = { 'jdtls' },
}

local function installed(name)
  local cfg = vim.lsp.config[name]
  if not cfg then return false end
  local bins = binaries[name] or { type(cfg.cmd) == 'table' and cfg.cmd[1] or nil }
  for _, bin in ipairs(bins) do
    if vim.fn.executable(bin) == 1 then return true end
  end
  return false
end

-- Vue: vue_ls handles HTML/CSS and delegates TypeScript to vtsls through
-- @vue/typescript-plugin, which ships inside @vue/language-server.
local vue_ls_bin = vim.fn.exepath('vue-language-server')
if vue_ls_bin ~= '' then
  local vue_pkg = vim.fs.dirname(vim.fs.dirname(vim.uv.fs_realpath(vue_ls_bin)))
  vim.lsp.config('vtsls', {
    filetypes = { 'vue' },
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = '@vue/typescript-plugin',
              location = vue_pkg,
              languages = { 'vue' },
              configNamespace = 'typescript',
            },
          },
        },
      },
    },
  })
else
  servers = vim.tbl_filter(function(s) return s ~= 'vtsls' end, servers)
end

local enabled = {}
for _, name in ipairs(servers) do
  if installed(name) and not (name == 'phpactor' and enabled.intelephense) then
    enabled[name] = true
    vim.lsp.enable(name)
  end
end

vim.lsp.config('terraformls', {
  init_options = {
    experimentalFeatures = {
      prefillRequiredFields = true, -- completing a resource fills required args
      validateOnSave = true,        -- `terraform validate` diagnostics on save
    },
  },
})

-- JSON/YAML schemas from SchemaStore (GitHub Actions, docker-compose,
-- buildspec, IAM-ish JSON, ...), matched by file name.
local schemastore = require('schemastore')
vim.lsp.config('jsonls', {
  settings = { json = { schemas = schemastore.json.schemas(), validate = { enable = true } } },
})

-- CloudFormation intrinsic functions as YAML tags (otherwise "Unresolved tag")
local cfn_tags = {}
for _, tag in ipairs({
  'And', 'Base64', 'Cidr', 'Condition', 'Equals', 'FindInMap', 'GetAZs', 'GetAtt',
  'If', 'ImportValue', 'Join', 'Not', 'Or', 'Ref', 'Select', 'Split', 'Sub',
}) do
  vim.list_extend(cfn_tags, { '!' .. tag, '!' .. tag .. ' sequence', '!' .. tag .. ' mapping' })
end
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = '' }, -- SchemaStore.nvim provides them
      schemas = schemastore.yaml.schemas(),
      customTags = cfn_tags,
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = { Lua = { workspace = { library = { vim.env.VIMRUNTIME } } } },
})

vim.diagnostic.config({
  -- full message as lines below the cursor's line only; other lines keep
  -- just the sign (virtual_text would repeat the same message on that line)
  virtual_lines = { current_line = true },
  severity_sort = true,
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'x',
      [vim.diagnostic.severity.WARN] = '⚠',
    },
  },
})

-- Built-in defaults already provide: K (hover), grn (rename), gra (code
-- action), grr (references), gri (implementation), gO (symbols),
-- [d / ]d (diagnostics), <C-s> in insert (signature help).
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('<A-]>', vim.lsp.buf.definition, 'Go to definition')
    map('<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>', 'Go to definition')
    map('<A-F12>', vim.lsp.buf.references, 'Find references')
    map('<leader>f', vim.lsp.buf.format, 'Format buffer')

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
