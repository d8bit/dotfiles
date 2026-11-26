# Changelog

All notable changes to these dotfiles, newest first. Built from the git history
(345 commits since 2015); older years are summarised per year.

## Unreleased

### Added
- **Java**: `jdtls` language server (via Mason) with completion, enabled
  when a JDK 25+ is available; Treesitter `java` parser.
- **Kubernetes manifests**: any YAML file with top-level `apiVersion` and `kind`
  gets the Kubernetes schema in yamlls, wherever it lives, plus CRD schemas
  from yamlls' CRD catalog (ExternalSecret, Karpenter, cert-manager, ...).
- **Helm**: `helm-ls` (via Mason) for chart templates and `values*.yaml`;
  `helm` filetype for `templates/*.yaml`, `*.tpl` and `NOTES.txt` in a dir with
  a `Chart.yaml`, `yaml.helm-values` for values files (2-space indent);
  Treesitter `helm` parser.
- **Statusline**: `k8s:<current-context>` in YAML/Helm buffers, read from
  `$KUBECONFIG`; turns red when the context name contains a protected
  environment (`prod`, `production`, `pro`, `admin`).
- **nvim-tree**: closes together with the last file — `:q` on the last
  editing window no longer leaves the tree behind, and `:bd` of the last file
  buffer closes the tree.

### Changed
- **Obsidian**: switched from the unmaintained `epwalsh/obsidian.nvim` to the
  community fork `obsidian-nvim/obsidian.nvim`. Commands are now
  `:Obsidian <subcommand>` (e.g. `:Obsidian new`) instead of `:ObsidianNew`;
  only vaults that exist on the machine are registered, and the plugin is not
  set up when none do. Note frontmatter now has only `date` and `tags`
  (no `id` or `aliases`).
  Dropped `nvim-cmp`: the fork completes through its own LSP server, which
  Neovim's built-in completion already handles.
- zsh: `VISUAL`/`EDITOR` set to `nvim`; `nvime` opens `nvim/init.lua`; removed
  the `env-d8bit` alias.

## 2026-11-12 — Neovim DevOps tooling

### Added
- **`nvim/lua/config/devops.lua`**
  - `:Tf <args>` runs terraform in a terminal split from the current file's
    directory, through zsh so the `env_indicator.sh` prod confirmation still
    applies; subcommand completion.
  - Terraform keymaps: `<leader>ti` init, `<leader>tv` validate,
    `<leader>tp` plan, `<leader>tf` fmt.
  - Format on save for `*.tf`, `*.tfvars`, `*.tftest.hcl` via terraform-ls.
  - Lualine segment with `DEPLOY_ENV`, AWS profile/region and terraform
    workspace; red in protected environments.
- **Mason** (`config/mason.lua`): installs language servers, linters and the
  tree-sitter CLI on startup and puts them on `$PATH`.
- **SchemaStore.nvim**: JSON/YAML schemas (GitHub Actions, docker-compose, ...).
- **LSP**: `jsonls`; CloudFormation tags (`!Ref`, `!Sub`, ...) for yamlls;
  terraform-ls prefill of required fields and validate on save.
- **Linters**: `tflint` (per module, nearest `.tflint.hcl`) and `trivy`
  (misconfigurations, MEDIUM and up) for Terraform, `hadolint` for Dockerfiles,
  `actionlint` for GitHub workflows, `cfn-lint` for CloudFormation templates.
- **Alacritty** config: 0.9 opacity, blinking block cursor, MesloLGM Nerd Font.

### Changed
- Linting runs on `FileType` instead of `BufReadPost`, so linters also run when
  a file is opened, not only on save.
- Diagnostics as virtual lines on the current line only.
- LSP detection accepts several binaries per server (`tsc` or `tsgo`).
- `:JsonBeautify` uses `jq`; `updatetime` 250 ms; Telescope ignores
  `.terraform/`; nvim-tree syncs across tabs and follows the current file.
- `.tfstate` opens as JSON, `.terraform.lock.hcl`/`.tflint.hcl` as HCL.
- `env_indicator.sh`: `dev` environment renamed to `test`.

## 2026-11-10 — Neovim rewritten in Lua

### Added
- New `nvim/` config for Neovim 0.12 replacing `init.vim`: `init.lua` plus
  `lua/config/{options,plugins,lsp,lint,keymaps}.lua`.
- Plugins managed by the built-in `vim.pack`, pinned in `nvim-pack-lock.json`.
- Built-in LSP client with nvim-lspconfig (PHP, Python, TypeScript/Vue,
  Terraform, Lua, YAML, Bash, Docker, LaTeX), enabled only when installed.
- nvim-lint (phpcs/phpmd with project rulesets), Treesitter, Telescope,
  nvim-tree, aerial, gitsigns, lualine, built-in undotree.

### Changed
- zsh: oh-my-zsh plugins extended (fzf, autosuggestions, syntax highlighting,
  aws, terraform, direnv, kubectl, ...); `env_indicator.sh` sourced from zshrc.

### Removed
- `init.vim` (vim-plug/NeoBundle based Neovim config).

## 2026 (May–October)

### Added
- `scripts/env_indicator.sh`: `envload`/`envunload`/`envwhich` to load
  environment files with a coloured prompt indicator, and a confirmation before
  `terraform apply/destroy/import` in protected environments. Replaces the old
  `AWS_PROFILE` prompt function.
- `encripted_backup` function in `utils.rc` to commit and archive notes vaults
  to an encrypted volume.

### Changed
- Vim: SGR mouse mode when available; markdownlint line-length rule disabled.
- zsh: `cat` alias renamed to `bcat`; more oh-my-zsh plugins (aws, fzf,
  git-flow, nvm, pip); Kiro shell integration.
- Backup scripts updated for new drive paths and more vaults.

## 2025

### Added
- `utils.rc` and `cron-scripts/` (KeePass backup, Obsidian cache cleanup and
  save automation), extracted from zshrc.
- Telescope (find files, buffers) in Vim/Neovim.
- Terraform aliases (per-environment init + plan); oh-my-zsh `kubectl`,
  `kube-ps1` and `kubectx` plugins.

### Changed
- Srcery colour scheme again.

## 2023

### Added
- `vimrc_cloudops`: Vim config for cloud/DevOps work.
- `<F5>` runs `:Git pull`.

### Changed
- ALE re-enabled; Phpactor and debugger mappings disabled.

## 2022

### Changed
- ALE disabled by default; `<F4>` (visual) aligns on `=` with Tabular;
  `<leader>r` strips trailing whitespace; 2-space indent for XML.

## 2021

### Added
- `noplugins_vimrc`: plugin-free Vim config; `basic_vimrc` refactored.
- Terraform completion, Terragrunt, Dockerfile and Nginx plugins;
  `*.DockerFile` and `*.es.conf` filetypes.
- zsh: `vi-mode` plugin, Terragrunt and environment aliases.

### Changed
- ALE moved to `dense-analysis/ale` and lints on open.

## 2020

### Added
- `vimScript.sh` to build and install the latest Vim from source.
- vim-terraform; `*.hcl` treated as Terraform; JSON 2-space indent.
- Gruvbox theme; coc.nvim tried and then disabled.

### Changed
- Vim simplified; tmux config updated for newer tmux; better mouse handling.

## 2019

### Added
- Goyo (`<leader>f`), vim-eunuch, Ansible YAML, Twitvim.
- coc.vim config experiment; zsh aliases.

### Changed
- `basic_vimrc`: always show tabline, autoindent, current-line highlight.
- 2-space indent for YAML, HTML, Blade.

### Removed
- lazygit plugin; vim-gitgutter disabled.

## 2018

### Added
- `editorconfig`; vim-sessions; LaTeX plugin and linter; Jenkinsfile syntax;
  CamelCaseMotion; JSON beautify command; spell-check toggles
  (`<leader>c`/`<leader>C`); `tmuxScript.sh` to restore tmux sessions.

### Changed
- ESLint rules updated (ES2017); phpcs uses PSR-2.
- Ag replaced by ripgrep; ctags replaced by GNU Global (gtags), shown in the
  statusline; FZF respects `.gitignore`.
- Airline → lightline → airline again; Sideways shortcuts; Srcery updated.

## 2017

### Added
- `buffers.vim` (`:Buffo`), `fzfbranch.vim` (switch git branch with FZF),
  `eslintrc.json`, `spacemacs`.
- Startify, undotree, Vue and TypeScript syntax, Twig, Ruby config, htmlhint,
  ESLint, colour preview plugin.
- Themes: ayu, spring-night, srcery (strings in red).
- zsh: Vim as default editor, FZF aliases, sbin on `PATH`.

### Changed
- vundle → vim-plug; CtrlP → FZF; Neomake → ALE.
- tmux prefix `C-h` → `C-s`.

### Removed
- Silver Searcher plugin, vim-grepper, Completor, Neocomplete.

## 2016

### Added
- `basic_vimrc`, `views.vim` (folds saved per file), `README.md`, `emacs`,
  `tern-config`, `zshrc`.
- tmux-themepack as a submodule; tmux-resurrect.
- Plugins: PHP namespaces, refactoring, phpcomplete, Blade, NERDTree tabs,
  Tabular, Sideways, quickfix toggle, xdebug, async grep, TypeScript and JS.
- Column 121 highlight, visible tabs and trailing whitespace, fold shortcuts,
  wildmenu; quantum theme.

### Changed
- Powerline → airline (Vim and tmux).
- Syntastic → Neomake (Vim 8); phpmd on save; jshint for JavaScript.
- No swap/backup files.

### Removed
- YouCompleteMe.

## 2015

### Added
- Initial `vimrc`: autocomplete, Tagbar, NERDTree, PHP linting, vim-repeat,
  incremental search, CtrlP, Silver Searcher, ctags shortcuts, omnicomplete,
  Syntastic, UltiSnips.
- `tmux.conf`: mouse, vi movements, split shortcuts, Powerline, macOS/Linux
  handling, `escape-time 0`.
- `php.snippets`, Monokai theme, `speedswapper` (Caps Lock ↔ Esc).
- `init.vim`: first Neovim config.
- MacVim font settings.

### Removed
- delimitMate, EasyMotion, solarized and moria themes.
