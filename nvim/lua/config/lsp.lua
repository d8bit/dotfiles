-- Built-in LSP client; server definitions come from nvim-lspconfig's lsp/ dir.
-- A server is enabled only if its executable is installed:
--   npm i -g intelephense pyright typescript @vtsls/language-server \
--     @vue/language-server yaml-language-server bash-language-server \
--     dockerfile-language-server-nodejs
--   brew install terraform-ls lua-language-server texlab
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
  'bashls',
  'dockerls',
  'texlab',
}

-- Some lspconfig servers define `cmd` as a function; name their binary here.
local binaries = {
  tsc = 'tsc',
  yamlls = 'yaml-language-server',
}

local function installed(name)
  local cfg = vim.lsp.config[name]
  if not cfg then return false end
  local bin = binaries[name] or (type(cfg.cmd) == 'table' and cfg.cmd[1])
  return bin and vim.fn.executable(bin) == 1
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

vim.lsp.config('lua_ls', {
  settings = { Lua = { workspace = { library = { vim.env.VIMRUNTIME } } } },
})

vim.diagnostic.config({
  virtual_text = true,
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
