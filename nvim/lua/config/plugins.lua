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

  -- obsidian
  gh('obsidian-nvim/obsidian.nvim'),
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
  'bash', 'blade', 'css', 'dockerfile', 'hcl', 'helm', 'html', 'java', 'javascript', 'json', 'lua',
  'markdown', 'markdown_inline', 'php', 'phpdoc', 'python', 'terraform', 'tsx',
  'twig', 'typescript', 'vim', 'vimdoc', 'vue', 'yaml',
}
if vim.fn.executable('tree-sitter') == 1 then
  require('nvim-treesitter').install(ts_langs)
end
vim.treesitter.language.register('yaml', 'yaml.helm-values')
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      -- Only use treesitter indent when the language ships an indents query;
      -- otherwise its indentexpr returns 0 and <CR> drops the cursor to col 0
      -- (dockerfile, helm, twig, vim...). Fall back to the ftplugin/autoindent.
      local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
      if lang and vim.treesitter.query.get(lang, 'indents') then
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end
  end,
})

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '^.git/', 'node_modules/', 'vendor/', '%.terraform/' },
    -- search dotfiles/dot-dirs (e.g. .github/) in grep pickers too, but never .git/
    vimgrep_arguments = {
      'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case', '--hidden', '--glob', '!**/.git/*',
    },
  },
  pickers = { find_files = { hidden = true } },
})

require('nvim-tree').setup({
  -- fixed width so it doesn't fight the auto-width autocmds below
  view = { width = 30, number = true, relativenumber = true },
  -- show dotfiles and git-ignored files (.kube/, .terraform/...); `I` toggles the latter
  filters = { dotfiles = false, git_ignored = false },
  -- keep the tree open/closed consistently across all tabpages
  tab = { sync = { open = true, close = true } },
  -- highlight the current buffer's file in the tree
  update_focused_file = { enable = true },
  -- icons need a Nerd Font in the terminal (MesloLGM Nerd Font in Alacritty)
  renderer = { icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
})

-- Close the tree together with the last file it accompanies
local tree_api = require('nvim-tree.api')
local is_tree_buf = function(buf) return vim.bo[buf].filetype == 'NvimTree' end

-- Auto-width: the tree grows to fit its content (MIN_W..MAX_W) while focused
-- and shrinks back to MIN_W when you leave it
local TREE_MIN_W, TREE_MAX_W = 30, 80

local function tree_content_width(win)
  local buf = vim.api.nvim_win_get_buf(win)
  local w = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    w = math.max(w, vim.fn.strdisplaywidth(line))
  end
  -- + number/sign columns (relativenumber is on) + a little margin
  return w + vim.fn.getwininfo(win)[1].textoff + 2
end

local function tree_resize(win, focused)
  if not (win and vim.api.nvim_win_is_valid(win)) then return end
  if not is_tree_buf(vim.api.nvim_win_get_buf(win)) then return end
  local width = TREE_MIN_W
  if focused then
    width = math.min(math.max(tree_content_width(win), TREE_MIN_W), TREE_MAX_W)
  end
  vim.api.nvim_win_set_width(win, width)
end

local tree_width_grp = vim.api.nvim_create_augroup('TreeAutoWidth', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  group = tree_width_grp,
  callback = function() tree_resize(vim.api.nvim_get_current_win(), true) end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = tree_width_grp,
  callback = function() tree_resize(vim.api.nvim_get_current_win(), false) end,
})
-- recalculate on redraw (expanding/collapsing folders, changes on disk)
tree_api.events.subscribe(tree_api.events.Event.TreeRendered, function(data)
  local win = vim.fn.bufwinid(data.bufnr)
  if win ~= -1 then tree_resize(win, win == vim.api.nvim_get_current_win()) end
end)

-- :q on the last regular window of a tab also closes the tree, instead of
-- leaving the tree as the only window (so :q quits nvim as expected)
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    local wins, trees = 0, {}
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(w).relative == '' then
        if is_tree_buf(vim.api.nvim_win_get_buf(w)) then
          table.insert(trees, w)
        else
          wins = wins + 1
        end
      end
    end
    if wins == 1 then
      for _, w in ipairs(trees) do pcall(vim.api.nvim_win_close, w, true) end
    end
  end,
})

-- :bd of the last file buffer closes the tree too.
-- Checked after the fact (not by excluding ev.buf): opening the first file
-- reuses the empty [No Name] buffer, which fires BufDelete on a buffer that
-- then holds the file. A real :bd leaves it unlisted, :bwipe makes it invalid.
vim.api.nvim_create_autocmd('BufDelete', {
  callback = function(ev)
    if is_tree_buf(ev.buf) or vim.bo[ev.buf].buftype ~= '' then return end
    vim.schedule(function()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(b)
        if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
          and vim.bo[b].buftype == '' and name ~= ''
          and vim.fn.isdirectory(name) == 0 then
          return
        end
      end
      if tree_api.tree.is_visible() then tree_api.tree.close() end
    end)
  end,
})

require('aerial').setup({
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  close_on_select = true,
  show_guides = true,
})

require('gitsigns').setup()

require('lualine').setup({
  -- theme switchable with :LualineTheme (see config/statusline.lua)
  options = { theme = require('config.statusline').saved(), icons_enabled = true },
  tabline = { lualine_a = { { 'buffers', mode = 2 } } },
  sections = {
    lualine_x = {
      require('config.devops').lualine, 'encoding', 'fileformat', 'filetype',
    },
  },
})

require('nvim-autopairs').setup()
require('neogen').setup()

-- obsidian-nvim/obsidian.nvim errors when no workspace path exists, so only
-- pass the vaults present on this machine and skip setup when there are none.
local obsidian_workspaces = vim.tbl_filter(function(ws)
  return vim.fn.isdirectory(vim.fn.expand(ws.path)) == 1
end, {
  { name = "obsidian_barcelo",      path = "~/Documents/barcelo/obsidian_barcelo/" },
  { name = "obsidian_virtual_cave", path = "~/Documents/virtualCave/obsidian_vc/" },
  { name = "obsidian_veci",         path = "~/Documents/veci//obsidian_veci//" },
})

if #obsidian_workspaces > 0 then
  require("obsidian").setup({
    legacy_commands = false, -- use `:Obsidian <subcommand>` instead of `:ObsidianX`
    workspaces = obsidian_workspaces,
    -- Frontmatter holds only `date` (kept once set) and `tags`, no id/aliases;
    -- any other properties already in a note are left untouched.
    frontmatter = {
      sort = { "date", "tags" },
      func = function(note)
        local out = vim.tbl_extend("force", {}, note.metadata or {})
        -- metadata carries id/aliases too (aliases even when empty): drop them
        out.id, out.aliases = nil, nil
        out.date = out.date or os.date("%Y-%m-%d")
        out.tags = note.tags
        return out
      end,
    },
  })

  -- Native LSP completion only auto-triggers on trigger characters (`[`), when
  -- obsidian-ls has nothing to offer yet (it needs completion.min_chars, 2, after
  -- `[[`). Re-request while typing inside an unclosed `[[` so links complete.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client or client.name ~= 'obsidian-ls' then return end
      vim.api.nvim_create_autocmd('TextChangedI', {
        buffer = ev.buf,
        callback = function()
          if vim.fn.pumvisible() == 1 then return end
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local query = vim.api.nvim_get_current_line():sub(1, col):match('%[%[([^%]|]*)$')
          if query and vim.fn.strchars(query) >= 2 then vim.lsp.completion.get() end
        end,
      })
    end,
  })
end
