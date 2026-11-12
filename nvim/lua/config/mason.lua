-- Mason installs language servers, linters and CLIs into
-- stdpath('data')/mason and puts its bin/ first on $PATH, so the
-- "is it installed?" checks in lsp.lua and lint.lua find them.
-- Anything missing from this list is installed in the background on startup;
-- restart Neovim once it finishes. :Mason shows status, U updates everything.
require('mason').setup()

local ensure_installed = {
  -- language servers
  'intelephense',
  'pyright',
  'tsgo', -- TypeScript 7 native server, used by the `tsc` config
  'vtsls',
  'vue-language-server',
  'terraform-ls',
  'lua-language-server',
  'yaml-language-server',
  'json-lsp',
  'bash-language-server',
  'dockerfile-language-server',
  'texlab',
  -- linters (nvim-lint)
  'phpcs',
  'phpmd',
  'tflint',     -- terraform: provider-aware lint (AWS rules via .tflint.hcl)
  'trivy',      -- terraform: security misconfigurations
  'cfn-lint',   -- CloudFormation templates
  'hadolint',   -- Dockerfiles
  'actionlint', -- GitHub Actions workflows
  'shellcheck', -- used by bash-language-server
  -- compiles nvim-treesitter parsers
  'tree-sitter-cli',
}

local registry = require('mason-registry')
registry.refresh(function()
  local missing = vim.tbl_filter(function(name)
    local ok, pkg = pcall(registry.get_package, name)
    return ok and not pkg:is_installed() and not pkg:is_installing()
  end, ensure_installed)
  if #missing == 0 then return end

  vim.schedule(function()
    vim.notify('Mason: installing ' .. table.concat(missing, ', '))
  end)
  local pending, failed = #missing, {}
  for _, name in ipairs(missing) do
    registry.get_package(name):install({}, function(success)
      if not success then table.insert(failed, name) end
      pending = pending - 1
      if pending == 0 then
        vim.schedule(function()
          if #failed > 0 then
            vim.notify('Mason: failed to install ' .. table.concat(failed, ', ')
              .. ' (see :Mason)', vim.log.levels.ERROR)
          else
            vim.notify('Mason: done, restart Neovim to use the new tools')
          end
        end)
      end
    end)
  end
end)
