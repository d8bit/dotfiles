# Changelog

## 2026-11-12

### Added
- **Neovim DevOps module** (`nvim/lua/config/devops.lua`)
  - `:Tf <args>` runs terraform in a terminal split from the current file's directory (through zsh, so the `env_indicator.sh` prod confirmation still applies), with subcommand completion.
  - Terraform buffer keymaps: `<leader>ti` init, `<leader>tv` validate, `<leader>tp` plan, `<leader>tf` fmt.
  - Format-on-save for `*.tf`, `*.tfvars`, `*.tftest.hcl` through terraform-ls.
  - Lualine segment showing `DEPLOY_ENV`, AWS profile/region and terraform workspace; turns red in protected environments (prod/pro/production/admin).
- **Plugins**: `mason.nvim` (puts tool binaries on `$PATH`) and `SchemaStore.nvim`.
- **LSP**: `jsonls`; SchemaStore schemas for JSON and YAML; CloudFormation intrinsic tags (`!Ref`, `!Sub`, ...) for yamlls; terraform-ls experimental features (prefill required fields, validate on save).
- **Linters**: `tflint` (per-module, nearest `.tflint.hcl`) and `trivy` (misconfig, MEDIUM+) for terraform, `hadolint` for Dockerfiles, `actionlint` for GitHub workflows, `cfn_lint` for CloudFormation templates.
- **Alacritty** config (`alacritty/alacritty.toml`): 0.9 opacity, blinking block cursor, MesloLGM Nerd Font.
- zsh alias `env-d8bit`.

### Changed
- LSP server detection accepts several binaries per server (`tsc` or `tsgo`); install docs now point to Mason.
- Diagnostics shown as virtual lines on the current line only, instead of virtual text everywhere.
- Linting runs on `FileType` instead of `BufReadPost` (filetype is now known on open), only for normal buffers, and skips linters whose condition or runtime (e.g. `php`) is missing.
- `:JsonBeautify` uses `jq` instead of `python3 -m json.tool`.
- `updatetime` lowered to 250ms; `terraform-vars` gets 2-space indent; `.tfstate` → json, `.terraform.lock.hcl`/`.tflint.hcl` → hcl.
- Telescope ignores `.terraform/`; nvim-tree syncs across tabs and follows the current file; lualine icons enabled.
- Treesitter CLI now installed via Mason.
- Bumped `nvim-tree.lua` and `vim-test`.
- `env_indicator.sh` / zshrc: `dev` environment renamed to `test` (`env-dev` → `env-test`); `ze` alias opens `~/.zshrc` in nvim.
