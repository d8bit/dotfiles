local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

-- Panels
map('n', '<leader>1', '<cmd>NvimTreeToggle<cr>', { desc = 'File tree' })
map('n', '<leader>2', '<cmd>AerialToggle<cr>', { desc = 'Symbol outline' })
map('n', '<leader>u', '<cmd>Undotree<cr>', { desc = 'Undo tree' })
cmd('Show', 'NvimTreeFindFile', { desc = 'Reveal current file in tree' })

-- Telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
map('n', '<C-space>', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
map('n', '<leader>g', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
cmd('Find', function(o)
  require('telescope.builtin').grep_string({ search = o.args })
end, { nargs = '*', desc = 'Grep for a literal string' })
cmd('Todo', function()
  require('telescope.builtin').grep_string({ search = 'TODO|FIXME|XXX', use_regex = true })
end, { desc = 'List TODO/FIXME/XXX' })

-- Buffers
map('n', '<tab>', '<cmd>bnext<cr>')
map('n', '<S-tab>', '<cmd>bprevious<cr>')
cmd('Buffo', function(o)
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted then
      if o.bang or not vim.bo[b].modified then
        vim.api.nvim_buf_delete(b, { force = o.bang })
      else
        vim.notify('Buffer ' .. b .. ' has unsaved changes (use :Buffo!)', vim.log.levels.WARN)
      end
    end
  end
end, { bang = true, desc = 'Delete all buffers except the current one' })
map('n', '<F2>', '<cmd>Buffo<cr>')

-- Editing
map('n', '<F3>', '<cmd>nohlsearch<cr>')
map('v', '<F4>', ':Tabularize /=<cr>')
map('n', '<S-h>', '<cmd>SidewaysLeft<cr>')
map('n', '<S-l>', '<cmd>SidewaysRight<cr>')
map('n', '<leader>d', '<cmd>Neogen<cr>', { desc = 'Generate doc comment' })
map('n', '<leader>j', '<cmd>Neogen<cr>', { desc = 'Generate doc comment' })
-- Jump between the blank fields of a generated doc comment
local function neogen_jump(dir, fallback)
  return function()
    local neogen = require('neogen')
    if neogen.jumpable(dir == 'prev' and -1 or nil) then
      return dir == 'prev' and neogen.jump_prev() or neogen.jump_next()
    end
    vim.api.nvim_feedkeys(vim.keycode(fallback), 'n', false)
  end
end
map('i', '<C-j>', neogen_jump('next', '<C-j>'), { desc = 'Next doc field' })
map('i', '<C-k>', neogen_jump('prev', '<C-k>'), { desc = 'Previous doc field' })
map('n', '<leader>a', vim.diagnostic.open_float, { desc = 'Diagnostic details' })
cmd('StripWhitespace', [[keeppatterns %s/\s\+$//e]], { desc = 'Remove trailing whitespace' })

-- Spell
map('n', '<leader>c', '<cmd>setlocal spell<cr>')
map('n', '<leader>C', '<cmd>setlocal nospell<cr>')

-- Formatting / filetype helpers
cmd('JsonBeautify', '%!jq .', {})
cmd('XMLBeautify', '%!xmllint --format -', {})
cmd('JS', 'set filetype=javascript', {})
cmd('PHP', 'set filetype=php', {})
cmd('HTML', 'set filetype=html', {})
