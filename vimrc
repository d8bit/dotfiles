" ----------------------------------------------------------------------------
"
"                                  Vim basics
"
" ----------------------------------------------------------------------------

set nocompatible              " be iMproved, required
filetype off                  " required

" enable mouse
set mouse=a
set termguicolors
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
colorscheme srcery
" tab to spaces
set tabstop=4 shiftwidth=4 expandtab
" tab for ruby
autocmd Filetype eruby setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
" allow to use backspace always in insert mode
set backspace=indent,eol,start
set autoindent
" hightlight current line
set cursorline
set relativenumber
set number
" incremental search
set incsearch
" hightlight search
set hlsearch
" show commands
set showcmd
" split options: create splits below and right by default
set splitbelow
set splitright
" remove esc delay to return to visual mode quickly
set timeoutlen=1000 ttimeoutlen=0
" set font for mvim
set guifont=Meslo\ LG\ M\ for\ Powerline:h12
" do not save swap and tmp files
set noswapfile
set nobackup
set nowritebackup
" hightlight column 81
set colorcolumn=81
" show tabs
" set nolist " hide special characters
set list
set listchars=tab:▸\ 
" show autocomplete options on bottom bar
set wildmenu
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" Do not open split window with doc when using Omnicompletion
set completeopt-=preview

" autosave and autoload views to save codefoldings
" source ~/dotfiles/views.vim
" Function to close all buffers except the current one
source ~/dotfiles/buffers.vim

if has("persistent_undo")
    set undodir=/tmp/
    set undofile
endif

" tree view
let g:netrw_liststyle = 3

" fit quickfix height
au FileType qf call AdjustWindowHeight(1, 3)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
        " number to float for division
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" ----------------------------------------------------------------------------
"
"                              Codelinters config
"
" ----------------------------------------------------------------------------

let g:ale_linters = {
\   'php': ['phpcs', 'phpmd', 'php'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'html': ['htmlhint'],
\   'typescript': ['tsuquyomi'],
\}
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_php_phpcs_standard = "PSR2"

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [[ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ]
      \           ],
      \   'right': [['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \              ['percent'],
      \              ['fileformat', 'fileencoding', 'filetype'],
      \            ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filename': 'LightLineFilename'
      \ },
      \ }
function! LightLineFilename()
  return expand('%')
endfunction

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

" ----------------------------------------------------------------------------
"
"                                   Eyecandy
"
" ----------------------------------------------------------------------------

" to start lightline
set laststatus=2

"""""" End Eye candy """"""

" ----------------------------------------------------------------------------
"
"                                   Shortcuts
"
" ----------------------------------------------------------------------------
"
" nerdtree
map <Leader>1 <plug>NERDTreeTabsToggle<CR>
" tagbar
nmap <Leader>2 :TagbarToggle<CR>
" fzf files
map <C-p> :Files<CR>
" ctags async
map <Leader>t :AsyncRun -post=copen ctags -R --exclude=node_modules --exclude=jquery --exclude=vendor --languages=php,javascript .<CR>
" multicursor shortcuts
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
" move lines with Control key
let g:move_key_modifier = 'C'
" move parameters
map <C-h> <Nop>
map <C-h> :SidewaysLeft<CR>
map <C-l> :SidewaysRight<CR>
" PHPDOC config
map <Leader>d :call PhpDoc()<CR>
" JSDOC config
map <Leader>j :JsDoc<CR>
" ultisnips
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
" use namespace plugin with <leader>e
autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>
" toggle quickfixlist and locationlist
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>
" phpmanual
let g:php_manual_online_search_shortcut = '<F1>'

" undotree
nnoremap <leader>u :UndotreeToggle<cr>

" noh
nnoremap <F3> :noh<cr>

" run script to make blockmayus = esc
" map <Leader>e :!xmodmap ~/.speedswapper<CR>

set wildignore+=vendor/**,node_modules/**
" command Todo noautocmd vimgrep /TODO\|FIXME\|XXX/j ** | cw
command Todo noautocmd Ag \/\/.TODO|\\/\/.FIXME|\/\/.XXX
command JS set filetype=javascript
command PHP set filetype=php
command HTML set filetype=html

" ----------------------------------------------------------------------------
"
"                                    Configs
"
" ----------------------------------------------------------------------------

" do not jump on autopairs
let g:AutoPairsMultilineClose = 0
" typescript options
let g:tsuquyomi_disable_quickfix = 1
" Tagbar
" hide php variables on tagbar
let g:tagbar_type_php  = {
  \ 'ctagstype' : 'php',
  \ 'kinds'     : [
          \ 'i:interfaces',
          \ 'c:classes',
          \ 'd:constant definitions',
          \ 'f:functions',
          \ 'j:javascript functions:1'
  \ ]
\ }
" tabgar autofocus and close on select
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_show_linenumbers = 2

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Nerdtree
" show line numbers on NerdTree
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1
" xdebug
" stop at breakpoints on debugging
let g:dbgPavimBreakAtEntry = 1
" Xdebug config
let g:vdebug_options= {
    \    "port" : 9000,
    \    "server" : '',
    \    "timeout" : 20,
    \    "on_close" : 'detach',
    \    "break_on_open" : 0,
    \    "ide_key" : '',
    \    "path_maps" : {},
    \    "debug_window_level" : 0,
    \    "debug_file_level" : 0,
    \    "debug_file" : "",
    \    "watch_window_style" : 'expanded',
    \    "marker_default" : '⬦',
    \    "marker_closed_tree" : '▸',
    \    "marker_open_tree" : '▾'
    \}

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Execute 'UltiSnipsAddFiletypes php' if necessary
let g:UltiSnipsSnippetsDir="~/.vim/plugged/vim-snippets/UltiSnips"
" namespace
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
" fzf options
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

"end my config

" ----------------------------------------------------------------------------
"
"                                    Bundle
"
" ----------------------------------------------------------------------------

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" File tree (nerdtree)
Plug 'https://github.com/scrooloose/nerdtree.git'
" nerdtree on all tabs
Plug 'jistr/vim-nerdtree-tabs'

" git integration. Show git info on nerdtree
Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin.git'

" git integration. Shows line state on margin.
Plug 'airblade/vim-gitgutter'

" git integration. Git commands.
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'junegunn/gv.vim'

" emmet plugin for html
Plug 'mattn/emmet-vim'

" multiple cursors
Plug 'https://github.com/terryma/vim-multiple-cursors.git'

" show functions and vars on current file
Plug 'https://github.com/majutsushi/tagbar.git'

" plugins for snippets
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'honza/vim-snippets'

" comment lines with gcc command
Plug 'tomtom/tcomment_vim'

" match tags with %
Plug 'https://github.com/tmhedberg/matchit.git'

" surround text objects
Plug 'https://github.com/tpope/vim-surround.git'

" move line with ctrl[j,k]
Plug 'https://github.com/matze/vim-move.git'

" repeat commands with '.' for surround plugin (among others)
Plug 'https://github.com/tpope/vim-repeat.git'

" debuger
" Plug 'https://github.com/joonty/vdebug.git'

" hightlight html tags
Plug 'https://github.com/gregsexton/MatchTag.git'

" code linter
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'

" auto-close
Plug 'https://github.com/jiangmiao/auto-pairs.git'

" generate phpdoc
Plug 'sumpygump/php-documentor-vim'

" generate jsdoc
Plug 'heavenshell/vim-jsdoc'

" autocomplete namespaces
Plug 'arnaud-lb/vim-php-namespace'

" refactor tool
Plug 'adoy/vim-php-refactoring-toolbox'

" lightline
Plug 'itchyny/lightline.vim'

" blade syntax
Plug 'jwalton512/vim-blade'

" php complete
Plug 'shawncplus/phpcomplete.vim'

" tern for javascript
Plug 'ternjs/tern_for_vim'
Plug 'pangloss/vim-javascript'
" reactjs (jsx)
Plug 'mxw/vim-jsx'

" php man (Ctrl-h for online manual, Shift-k for vim explanation)
Plug 'alvan/vim-php-manual'

" python doc
Plug 'fs111/pydoc.vim'

" show whitespaces at the end of the lines
Plug 'ntpeters/vim-better-whitespace'

" tabular plugin to format text
Plug 'godlygeek/tabular'

" asyncronous commands
Plug 'skywind3000/asyncrun.vim'

" switch parameters
Plug 'AndrewRadev/sideways.vim'

" twig hightlight
Plug 'lumiliet/vim-twig'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" typescript hightlight
Plug 'leafgarland/typescript-vim'

" grep integration
" Plug 'grep.vim'

" comments
Plug 'jeanguyomarch/vim-metacomment'

" startify
Plug 'mhinz/vim-startify'

" undo tree
Plug 'mbbill/undotree'

" VueJS
Plug 'posva/vim-vue'

" show colors in code
Plug 'ap/vim-css-color'

" Unit Testing
Plug 'janko-m/vim-test'

" Camelcase motion
Plug 'vim-scripts/camelcasemotion'

" Jenkinsfile syntax
Plug 'martinda/Jenkinsfile-vim-syntax'

" devicons
" Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()
filetype plugin indent on    " required
syntax enable
:
