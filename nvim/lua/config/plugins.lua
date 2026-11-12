local gh = function(repo) return 'https://github.com/' .. repo end

-- Build hooks; must be registered before vim.pack.add() to catch installs
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

-- Plugin globals read when plugin/ files are sourced
vim.g.move_key_modifier = 'C'
vim.g.camelcasemotion_key = ','

vim.pack.add({
  -- core / libs
  gh('nvim-lua/plenary.nvim'),
  gh('neovim/nvim-lspconfig'),
  gh('mason-org/mason.nvim'),
  gh('b0o/SchemaStore.nvim'),
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },

  -- navigation
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-tree/nvim-web-devicons'),
  gh('nvim-tree/nvim-tree.lua'),
  gh('stevearc/aerial.nvim'),

  -- git
  gh('lewis6991/gitsigns.nvim'),
  gh('tpope/vim-fugitive'),
  gh('junegunn/gv.vim'),

  -- ui
  gh('srcery-colors/srcery-vim'),
  gh('nvim-lualine/lualine.nvim'),

  -- editing
  gh('windwp/nvim-autopairs'),
  gh('danymat/neogen'),
  gh('tpope/vim-surround'),
  gh('tpope/vim-repeat'),
  gh('tpope/vim-eunuch'),
  gh('matze/vim-move'),
  gh('mg979/vim-visual-multi'),
  gh('mattn/emmet-vim'),
  gh('godlygeek/tabular'),
  gh('AndrewRadev/sideways.vim'),
  gh('bkad/CamelCaseMotion'),

  -- tooling
  gh('mfussenegger/nvim-lint'),
  gh('vim-test/vim-test'),
  gh('lervag/vimtex'),
}, { confirm = false })

-- Puts Mason's bin/ on $PATH; must run before any executable() checks
require('config.mason')

pcall(vim.cmd.colorscheme, 'srcery')

-- Built-in optional packages (Neovim 0.12)
vim.cmd.packadd('nvim.undotree')

-- Treesitter: parsers are compiled with the `tree-sitter` CLI (installed by
-- Mason). Without it only the bundled parsers (lua, vim, vimdoc, markdown,
-- query, c) are available.
local ts_langs = {
  'bash', 'blade', 'css', 'dockerfile', 'hcl', 'html', 'javascript', 'json', 'lua',
  'markdown', 'markdown_inline', 'php', 'phpdoc', 'python', 'terraform', 'tsx',
  'twig', 'typescript', 'vim', 'vimdoc', 'vue', 'yaml',
}
if vim.fn.executable('tree-sitter') == 1 then
  require('nvim-treesitter').install(ts_langs)
end
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '^.git/', 'node_modules/', 'vendor/', '%.terraform/' },
  },
  pickers = { find_files = { hidden = true } },
})

require('nvim-tree').setup({
  view = { number = true, relativenumber = true },
  filters = { dotfiles = false },
  -- keep the tree open/closed consistently across all tabpages
  tab = { sync = { open = true, close = true } },
  -- highlight the current buffer's file in the tree
  update_focused_file = { enable = true },
  -- icons need a Nerd Font in the terminal (MesloLGM Nerd Font in Alacritty)
  renderer = { icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
})

require('aerial').setup({
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  close_on_select = true,
  show_guides = true,
})

require('gitsigns').setup()

require('lualine').setup({
  options = { theme = 'auto', icons_enabled = true },
  tabline = { lualine_a = { { 'buffers', mode = 2 } } },
  sections = {
    lualine_x = {
      require('config.devops').lualine, 'encoding', 'fileformat', 'filetype',
    },
  },
})

require('nvim-autopairs').setup()
require('neogen').setup()
